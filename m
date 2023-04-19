Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3E206E70BE
	for <lists+io-uring@lfdr.de>; Wed, 19 Apr 2023 03:29:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231496AbjDSB3x (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 18 Apr 2023 21:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbjDSB3x (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 18 Apr 2023 21:29:53 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D75E6183
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 18:29:52 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-63b781c9787so1094854b3a.1
        for <io-uring@vger.kernel.org>; Tue, 18 Apr 2023 18:29:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1681867792; x=1684459792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CTWQHeFJ3ejIWTMeS4au4uWFQrR7IGwBMPklLJD51kM=;
        b=iY7gk4ydmQXDkfNyu+MZGQblceMwQfO/z23bL/cPtba2iVUF4SzsDTs/xKVDOiBpUT
         I0ltsqqaDT7SgbUVaANpQf+201Hzyy2FIuVXbK2SlZbDSIvw6bWL3pD7zFySlNYZvzb/
         sx3OatojqqQpZPP6EWjo16Ds6J7w/ZPNXVLhKpNPLwXMeCuw+ckAC7WMmUuO+6431lOt
         ebBE3LEupU+uIdn9IM6MqN7eumxHmVVW6V2sr+z7+4MSFnzphBV83lVJIO+jTPSUfdsl
         uMCzKP39dKDyV1zjX1MjQnT2BhA7LwvYhQtq0pBrHmvB6HOjJKR6guyu11o5zochPLch
         B+fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681867792; x=1684459792;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CTWQHeFJ3ejIWTMeS4au4uWFQrR7IGwBMPklLJD51kM=;
        b=EY9Y0v6GrAegomiJ/VlFqGnYwgvpteIMvrTNHsP2MvO1R2ghDUjaVqDHcj3cJiKyuS
         XzWKed4ExnbaG0M3O8ZJUv19TA4dS4eIN/4eErfAMcQ5wJcXBePAmwqyPSqTpsPuR+KO
         NAY0oSTIJ+b2EoH2jmVtwJ/ZIJYRRU8/Mtm324HKyNOIc5yGR+SlQqEtfTxwTTQlqGCl
         hA8fsINQfLG7tlar5h6u24cvnJcTL3Vze5ExOf9GeO2hrrPxJnlorMSNbADj9sBpggie
         P8KyJYHW5xisYTALhLuGL6FnYQTbNlti/DDLvLh0uh8XYuM1EsEfF6K4NdIRFQlsYo4n
         ERAw==
X-Gm-Message-State: AAQBX9ewOJDpnp3wsh1ERoEc2dvZnnDzbqNGt5SvkzbB/ZlTcxPuC3eh
        TVTpE+5s+VJ8W8Ymq73b1hxSl/a9Xtm4nM2FJW8=
X-Google-Smtp-Source: AKy350YgGFc6D4OlqyGc33XUajSpTxBulscq4UQTfX2cwKFjfV1dXXkb1fTZFkeeErOvr00LW2LV5w==
X-Received: by 2002:a05:6a21:339a:b0:cb:af96:9436 with SMTP id yy26-20020a056a21339a00b000cbaf969436mr18922152pzb.0.1681867791653;
        Tue, 18 Apr 2023 18:29:51 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id q12-20020a631f4c000000b0051b8172fa68sm6508791pgm.38.2023.04.18.18.29.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Apr 2023 18:29:51 -0700 (PDT)
Message-ID: <74244cb8-abf5-b559-5e9f-24d39c801855@kernel.dk>
Date:   Tue, 18 Apr 2023 19:29:50 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH 1/2] fs: add FMODE_DIO_PARALLEL_WRITE flag
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        "Darrick J. Wong" <djwong@kernel.org>
Cc:     Miklos Szeredi <miklos@szeredi.hu>,
        Bernd Schubert <bschubert@ddn.com>, io-uring@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-xfs@vger.kernel.org, dsingh@ddn.com
References: <20230307172015.54911-2-axboe@kernel.dk>
 <20230412134057.381941-1-bschubert@ddn.com>
 <CAJfpegt_ZCVodOhQCzF9OqKnCr65mKax0Gu4OTN8M51zP+8TcA@mail.gmail.com>
 <ZDjggMCGautPUDpW@infradead.org> <20230414153612.GB360881@frogsfrogsfrogs>
 <ZDuNqQgpHUw+gi9G@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZDuNqQgpHUw+gi9G@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 4/15/23 11:54?PM, Christoph Hellwig wrote:
> On Fri, Apr 14, 2023 at 08:36:12AM -0700, Darrick J. Wong wrote:
>> IIUC uring wants to avoid the situation where someone sends 300 writes
>> to the same file, all of which end up in background workers, and all of
>> which then contend on exclusive i_rwsem.  Hence it has some hashing
>> scheme that executes io requests serially if they hash to the same value
>> (which iirc is the inode number?) to prevent resource waste.
>>
>> This flag turns off that hashing behavior on the assumption that each of
>> those 300 writes won't serialize on the other 299 writes, hence it's ok
>> to start up 300 workers.
>>
>> (apologies for precoffee garbled response)
> 
> It might be useful if someone (Jens?) could clearly document the
> assumptions for this flag.

I guess it can be summed up as the common case should not be using
exclusive (per file/inode) locking. If file extensions need exclusive
locking that's less of a concern, as I don't think it's unreasonable to
expect that to require stricter locking.

-- 
Jens Axboe

