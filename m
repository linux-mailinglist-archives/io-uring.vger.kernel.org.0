Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 633E053358F
	for <lists+io-uring@lfdr.de>; Wed, 25 May 2022 05:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236246AbiEYDAa (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 24 May 2022 23:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232805AbiEYDAa (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 24 May 2022 23:00:30 -0400
Received: from mail-pj1-x1029.google.com (mail-pj1-x1029.google.com [IPv6:2607:f8b0:4864:20::1029])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0C662D1FB
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 20:00:28 -0700 (PDT)
Received: by mail-pj1-x1029.google.com with SMTP id ds11so18525328pjb.0
        for <io-uring@vger.kernel.org>; Tue, 24 May 2022 20:00:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=ByI6CYMNsy1pdUuDeEoCMLN+HTWTDI7iUv9pumDBZ2A=;
        b=jUJT0qUiyfZ9ZnlDABndPEmzb6WnxY6Tt4+fENIIwQ1UX8DfpDLAilPt+JcN0qhvcJ
         Cj8Pg5tOLGdHB288h5ozzMImL3j3+ZsaAzF1JzModpOXI/fovuwNUHLPleSI3rTfMSmR
         WcrgDCi+jiPJr9LUTOfUKSkTaV9JeIdB1IbMNsX0TIkQ7ypg3a0CFuh+jkir8XvmtPZQ
         EWVd63jJj9VJ27Sttaucofc7oULIAnRtBSMXkACGXo/16wUYVIjWQDnJJCkVjcByZKdq
         HtViwq//U4Ka+NHoq0QZplQgGhK8e7m8MC3IFrhRkvyUJFlqjJqTwKTsMU6LwwSKpB1B
         qLHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ByI6CYMNsy1pdUuDeEoCMLN+HTWTDI7iUv9pumDBZ2A=;
        b=M3QHLcNu1FSBZQ009A68j4z/h7yZlfxVlZc2thdqQV0cduc4kq1DXxE6fA7ZMRHwOq
         x7Y2teBaeJb0A9SvGoKie/sYmEoCVtiDcha85rxb/l73LEzLVjPmpqHez0Uj2ksPWSL4
         oNA09W23DAXvuhDbDvjO6az51fM9/dU6FRHBnBIr+wQvEc8hfJUiLrkObYh3u9qzobC4
         LsugRPvbLTMOzmAoCfkjElvcMW6/u0Y2ejPpDRfuftC2XmQJTZB7UT1B2XNH5ofEBBvA
         v8UeLaz6YXrsV5f5St3sc3dRKSK9Nnm/Jz6MEmDupOY17H3B7YBqYGGNGDPJUdhPU/DZ
         YjeA==
X-Gm-Message-State: AOAM532NiGaZBkrrMt3egJZyVFbdtYfwfABoVZAcczVk53h5FS0DevoK
        eR/rYia23Ng+CbtpHh7Bbh27tLYKqx30zA==
X-Google-Smtp-Source: ABdhPJyXYmgn5qb5hIlwbqbIFJJTrrPje22YYb//ISjgm0KN5q5T/ou4BLc/PuKxEz54fVDTP25vPg==
X-Received: by 2002:a17:902:7c0a:b0:15e:f63b:9a14 with SMTP id x10-20020a1709027c0a00b0015ef63b9a14mr30752364pll.35.1653447628070;
        Tue, 24 May 2022 20:00:28 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id g20-20020a625214000000b0050dc76281c4sm10003925pfb.158.2022.05.24.20.00.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 May 2022 20:00:27 -0700 (PDT)
Message-ID: <921eb447-d3f8-95d3-4ed7-c087bbcfd44c@kernel.dk>
Date:   Tue, 24 May 2022 21:00:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: io uring support for character device
Content-Language: en-US
To:     Changman Lee <cm224.lee@gmail.com>, io-uring@vger.kernel.org
References: <CAN863PsXgkvi-NLhyLy-M+iQgaWeXtjM_MBoRc0H0fq2jTfU1w@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAN863PsXgkvi-NLhyLy-M+iQgaWeXtjM_MBoRc0H0fq2jTfU1w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/24/22 6:56 PM, Changman Lee wrote:
> Hi List,
> 
> I'm CM Lee. I'm developing a custom character device managing pcie dma.
> I've tried to use io uring for the char device which supports readv
> and writev with synchronous and blocking manner and seek.
> When I use a io uring with IORING_SETUP_IOPOLL and IORING_SETUP_SQPOLL
> for reducing syscall overhead, a readv of the char device driver seems
> to be not called. So I added a_ops->direct_IO when the device is
> opened with O_DIRECT. But the result was the same.
> This is my question.
> Q1: Does io uring support a character device ?
> Q2: Is it better to reimplement a device driver as block device type ?

io_uring doesn't care what file type it is, I suspect your problem lies
elsewhere. Do you have a ->read() defined as well? If you do, the vfs
will pick that over ->read_iter().

If regular read/write works with O_DIRECT and reading from the device in
general, then io_uring will too.

-- 
Jens Axboe

