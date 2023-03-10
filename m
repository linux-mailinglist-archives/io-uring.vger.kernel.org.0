Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B176B346E
	for <lists+io-uring@lfdr.de>; Fri, 10 Mar 2023 03:58:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229580AbjCJC6h (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 9 Mar 2023 21:58:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbjCJC6g (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 9 Mar 2023 21:58:36 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4CA1EABA4
        for <io-uring@vger.kernel.org>; Thu,  9 Mar 2023 18:58:33 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id i5so4210411pla.2
        for <io-uring@vger.kernel.org>; Thu, 09 Mar 2023 18:58:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678417113;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eOeCMVB672mLPzz4xMQGfSjCt9QqSz92AVVf4Bg7VVk=;
        b=05zFgUtNoX1iBHpqqStJqFRmIN4boiDhhFtR3MztlAD3Q3ZnNAgrJfS6qQ2jaVimbc
         s3CPzfnFmHqDMi95SvY/2Rycky8I0VCWdt6BXPWOyq9k180ca0qRunI0ZYpiEks656d3
         chnueSbOun7FtTUsvwujcupZwCDmBhd0kRP5WSc9F+9Gy+kl/N+zeBZ+B43O1XGlCPBa
         Vxu2pfQfAkgd/qiYS2p9KrcaxTU97BuEazDXD8/qC3eCf5i1WYb72NFI0gFqCFbSrG2a
         FAV3EXXfrEpSDEubiWMXaWShWbO5KZ4xoQEHiPTZjmK2IxNlXgEA6wjty3QMo2buX5xZ
         Ou0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678417113;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eOeCMVB672mLPzz4xMQGfSjCt9QqSz92AVVf4Bg7VVk=;
        b=0IIfgc/6zEOID9Pyd0GS5QV4tInKxYh2S/m5NS+a5cvOC292hM6Nbdp0aJsfSsdEJu
         4DpNSuaXeEDospuJprdcI9IWWXl5U+z+NSNEb9amtvZ7xYcPc5mjUjU/iuF21jHxtgas
         RL9iMYiQhRuwpm4oTMMa2BG2005NwDObgfh/V5nLFpybCvdL8FuoJvVZax3UbthOfbvv
         QtuCzZG7HVcnOvcxEKvZkcWtsFh7dfYPk44HluJ10e95NI13J9Po7eocLKeszHA10UP7
         FUrLFabBcx+MRyXhqiYM5wU0Eq8xGK+zQrRRsnCh6ECf+g5CkET0BnbL0L2Vj5eWgECf
         pRrA==
X-Gm-Message-State: AO0yUKUKGynEOcweNvLRpU5/2tkjgPVLBbZ7b7IcZfhWaZZPbJNoV4fy
        gl7uTSdZRdi1ieX/KkOVx76FwQ==
X-Google-Smtp-Source: AK7set8ZyXChPaIcceiv0pwJi8H5qnfCkjYGpNIRGi5rGWG4+IrsIce0wTWZkJzVPDvgPkQJ5OJzSw==
X-Received: by 2002:a05:6a20:6914:b0:cc:4118:65c4 with SMTP id q20-20020a056a20691400b000cc411865c4mr1414702pzj.5.1678417113154;
        Thu, 09 Mar 2023 18:58:33 -0800 (PST)
Received: from ?IPV6:2600:380:8747:c8d0:5213:cd32:8419:a625? ([2600:380:8747:c8d0:5213:cd32:8419:a625])
        by smtp.gmail.com with ESMTPSA id w2-20020a1709026f0200b0019aa6bf4450sm297260plk.188.2023.03.09.18.58.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Mar 2023 18:58:32 -0800 (PST)
Message-ID: <2f928d56-a2ff-39ef-f7ae-b6cc1da4fc42@kernel.dk>
Date:   Thu, 9 Mar 2023 19:58:31 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: Resizing io_uring SQ/CQ?
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
Cc:     io-uring@vger.kernel.org
References: <20230309134808.GA374376@fedora>
 <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ZAqKDen5HtSGSXzd@ovpn-8-16.pek2.redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/9/23 6:38?PM, Ming Lei wrote:
> On Thu, Mar 09, 2023 at 08:48:08AM -0500, Stefan Hajnoczi wrote:
>> Hi,
>> For block I/O an application can queue excess SQEs in userspace when the
>> SQ ring becomes full. For network and IPC operations that is not
>> possible because deadlocks can occur when socket, pipe, and eventfd SQEs
>> cannot be submitted.
> 
> Can you explain a bit the deadlock in case of network application? io_uring
> does support to queue many network SQEs via IOSQE_IO_LINK, at least for
> send.
> 
>>
>> Sometimes the application does not know how many SQEs/CQEs are needed upfront
>> and that's when we face this challenge.
> 
> When running out of SQEs,  the application can call io_uring_enter() to submit
> queued SQEs immediately without waiting for get events, then once
> io_uring_enter() returns, you get free SQEs for moving one.
> 
>>
>> A simple solution is to call io_uring_setup(2) with a higher entries
>> value than you'll ever need. However, if that value is exceeded then
>> we're back to the deadlock scenario and that worries me.
> 
> Can you please explain the deadlock scenario?

I'm also curious of what these deadlocks are. As Ming says, you
generally never run out of SQEs as you can always just submit what you
have pending and now you have a full queue size worth of them available
again.

I do think resizing the CQ ring may have some merit, as for networking
you may want to start smaller and resize it if you run into overflows as
those will be less efficient. But I'm somewhat curious on the reasonings
for wanting to resize the SQ ring?

-- 
Jens Axboe

