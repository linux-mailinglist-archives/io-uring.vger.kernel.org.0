Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8E2201C84B4
	for <lists+io-uring@lfdr.de>; Thu,  7 May 2020 10:22:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725849AbgEGIWS (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 7 May 2020 04:22:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725802AbgEGIWR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 7 May 2020 04:22:17 -0400
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FA19C061A10
        for <io-uring@vger.kernel.org>; Thu,  7 May 2020 01:22:17 -0700 (PDT)
Received: by mail-wm1-x335.google.com with SMTP id x4so5409968wmj.1
        for <io-uring@vger.kernel.org>; Thu, 07 May 2020 01:22:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:cc:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=RYsdJgMVI4EmksecG85zFIGfWLnetjCs9IAGhikztdM=;
        b=GUGw/ULCHBhuw6jrbzPTpvvbmkAe7jtg6gTwCQ3ijmRXmQBn9b3wE9SFmGwLe/Wqh8
         Vz3HRsF/2VFD2s+WrRFTsb/ev2PtYifUMhrVnSSah75apvAgx5Rw9RPYof88KD/TgZe1
         4C0MSAUoiZRRkp5V+ui7uyiTYyZ9ckkXURJkXrqYfMhNDtXOrDAFC8FRxrizD6X2oFam
         746DXNuv5DKniVCW5hRAgVsVsSluNGj5UCNrxyidpy4T4nYNSl4QvT+LGuBxOdZUNOqH
         erNqduyOIRKnVdmnvkCltXzXmAicWl/1myO/jLHISsFRkPNGrCL0z9E7+1LyT4seqoya
         QS+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:autocrypt:subject
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=RYsdJgMVI4EmksecG85zFIGfWLnetjCs9IAGhikztdM=;
        b=Utdgw9Q2angY+6uYbGfl5hyOA/whpaQZRuSBlWBfMJL5ACPrMBA4dhOGcod325pm+T
         1s8AozrvcO7MXRtjTeZKJLDX2N/Dg+UIhaNPBMaXVOuNQU5PRaT9+APY9nlTIJAzUy48
         8UATblBJYYyHO2yjx3UDNS+CQQ+/SGlLwhBnvo2feudznId4iJkM3PwnDujeNP/xgtD9
         8nrgTZmI4Cz8X7EEU37rFDMIVUVdBDLgpcFxZYvzSoosD1J7sgWpLVs7un76BBCDQuB5
         Wtc5YAha/LYHGxGzMxQrDOxDjVva3ixSu4biC//X0x5EdLFJmINjiH3Cpsd881W/9DiG
         3upg==
X-Gm-Message-State: AGi0PuasGn+uJYsCmQa3oL02sCEm5V4X23TjJzEbOhJXqm8idh5w0Eon
        vFsIkP6GA/XW9nYcktwO51k=
X-Google-Smtp-Source: APiQypLWNnBwJereasiqBKXeSbX1REVXIUeuo5S3SKCVJwRigTWFMmqLw1ioQmbRFByhxfaHGQyg6g==
X-Received: by 2002:a1c:3c87:: with SMTP id j129mr8650245wma.157.1588839735547;
        Thu, 07 May 2020 01:22:15 -0700 (PDT)
Received: from [192.168.43.168] ([46.191.65.149])
        by smtp.gmail.com with ESMTPSA id f7sm6488655wrt.10.2020.05.07.01.22.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 May 2020 01:22:15 -0700 (PDT)
To:     "Bhatia, Sumeet" <sumee@amazon.com>,
        "io-uring@vger.kernel.org" <io-uring@vger.kernel.org>
Cc:     "Hegde, Pramod" <phegde@amazon.com>
References: <1588806165324.88604@amazon.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: Is it safe to submit and reap IOs in different threads?
Message-ID: <4a364d95-d80e-979e-dc18-c17e6b2e4e3c@gmail.com>
Date:   Thu, 7 May 2020 11:21:01 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <1588806165324.88604@amazon.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 07/05/2020 02:02, Bhatia, Sumeet wrote:
> Hello,
> 
> My application has a thread per disk (aka producer_thread) that generates disk operations. I have io-uring context per disk to ensure iouring submissions are from a single thread.
> 
> producer_thread executes only if new disk operations are to be submitted else it yields. It'll be significant code change to modify this behavior. For this reason I spin up a new thread (aka consumer thread) per io-uring context to reap IO completions.
> 
> My reading of fs/io_uring.c suggests it is safe to submit IOs from producer_thread and reap IOs from consumer_thread. My prototype based on liburing (Ref: https://pastebin.com/6u2FZB0D) works fine too. 
> 
> I would like to get your thoughts on whether this approach is indeed safe or am I overlooking any race condition?

Shortly, if you don't mix up submissions and completions, it's safe. There is
only pitfall I found in liburing -- you shouldn't pass a timeout in wait
functions (e.g. io_uring_wait_cqes()), which would do submission.

Also take a look:
https://github.com/axboe/liburing/issues/108#issuecomment-619616721

-- 
Pavel Begunkov
