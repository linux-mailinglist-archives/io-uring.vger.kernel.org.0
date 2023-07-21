Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4CCC275CCB8
	for <lists+io-uring@lfdr.de>; Fri, 21 Jul 2023 17:54:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232250AbjGUPyS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 21 Jul 2023 11:54:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231733AbjGUPyL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 21 Jul 2023 11:54:11 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46BCD1710
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 08:53:55 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id ca18e2360f4ac-7748ca56133so20850039f.0
        for <io-uring@vger.kernel.org>; Fri, 21 Jul 2023 08:53:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1689954834; x=1690559634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=O4ARo/yeOTiBgmP0k36MZmETrc39lrjPt/j+rt2AQLs=;
        b=gBpNGmA3y3F4Ogo7q7QOWMw3ChKxkE9O805A8TeP9W7Ew9QLy6COgUj2RENTfIZ7DV
         /Ile+y3EGXiqaG4w3xesg2Lo0nFAhyuvFkTqPcMlovSlWbZLBMSfzGNZMUPc1+rsfJbb
         5rAJovP6G7gXWhTzj7J0hwqK8UbSOOMttBTtrDSkTpqp3KBgU9R4hrnrwovJ4Hh0mPj+
         Orze/7IUGL880jyuTS0FA4DSW4EUwv/Nf4n6AchUuNinYqqdVPmf7b1dqYcc6WsxmSMF
         9Vioj8+24Huati3gLd8go7DMvk6HUCi3VVs06QmTPMPBBweCeZ9IoWjHcPgMVHrWyifO
         Bvlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689954834; x=1690559634;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O4ARo/yeOTiBgmP0k36MZmETrc39lrjPt/j+rt2AQLs=;
        b=eI4hQqRICiMdrTnsnbYxD2SS73VqL4HrqHoI4PSRmr6PeI55frJVDZjuAQTWi62asM
         afpoSTWuwJSqnv0qDMqUj5J19nHYGa9tYhPW7ps8FCwF5GF7Xls0Nrxv8XmWwY9Dtz0R
         t2mG4izshj3QYX+txeT1P1byqUYFxXPEVrJsWhMBN/mHWt/vGdl958jv3mAAMRTOYc3V
         yISIBd9ThpZ5c2kNMXij6c1fC+seEOB/PeZbejAipe4CPTrVZkOrLCdd70z1s+SStb7D
         OsrNaBwdOymc44fIPrNqNHBIf42FNpdBLTzfU8RasyOFh2Pro1NwU6q9LeqK/PjOOv0T
         WyWw==
X-Gm-Message-State: ABy/qLZRCX4cDqquTdPmFnLNIA+XzRr4B41+tQBTj8nbrL4UYBTWNlxg
        dHWQGqyz1beZMpbsfvfDvFcBsQ==
X-Google-Smtp-Source: APBJJlEEmTQ/d8r7kyEOemx68DPGN+UrWLxPwqY2XR6uq4PCmBJ1Xr7E2En6E6P54FgMNfxkMqbsnA==
X-Received: by 2002:a05:6602:4809:b0:77a:ee79:652 with SMTP id ed9-20020a056602480900b0077aee790652mr2281366iob.1.1689954834704;
        Fri, 21 Jul 2023 08:53:54 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o3-20020a02cc23000000b0042b6978ccc7sm1094738jap.94.2023.07.21.08.53.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 21 Jul 2023 08:53:53 -0700 (PDT)
Message-ID: <480a5dfe-dc7d-adea-9e6a-1c149a0844ab@kernel.dk>
Date:   Fri, 21 Jul 2023 09:53:53 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 7/8] io_uring/rw: add write support for IOCB_DIO_DEFER
Content-Language: en-US
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     io-uring@vger.kernel.org, linux-xfs@vger.kernel.org, hch@lst.de,
        andres@anarazel.de, david@fromorbit.com
References: <20230720181310.71589-1-axboe@kernel.dk>
 <20230720181310.71589-8-axboe@kernel.dk>
 <20230721155034.GP11352@frogsfrogsfrogs>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230721155034.GP11352@frogsfrogsfrogs>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/21/23 9:50?AM, Darrick J. Wong wrote:
> On Thu, Jul 20, 2023 at 12:13:09PM -0600, Jens Axboe wrote:
>> If the filesystem dio handler understands IOCB_DIO_DEFER, we'll get
>> a kiocb->ki_complete() callback with kiocb->dio_complete set. In that
>> case, rather than complete the IO directly through task_work, queue
>> up an intermediate task_work handler that first processes this
>> callback and then immediately completes the request.
>>
>> For XFS, this avoids a punt through a workqueue, which is a lot less
>> efficient and adds latency to lower queue depth (or sync) O_DIRECT
>> writes.
>>
>> Only do this for non-polled IO, as polled IO doesn't need this kind
>> of deferral as it always completes within the task itself. This then
>> avoids a check for deferral in the polled IO completion handler.
>>
>> Signed-off-by: Jens Axboe <axboe@kernel.dk>
> 
> Seems pretty obvious to me, though I'm famous for not being an
> experienced io_uring user yet...
> 
> Reviewed-by: Darrick J. Wong <djwong@kernel.org>

Thanks, keyword here is "yet" ;-)

-- 
Jens Axboe

