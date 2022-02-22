Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 527A64C0546
	for <lists+io-uring@lfdr.de>; Wed, 23 Feb 2022 00:19:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232424AbiBVXUL (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Feb 2022 18:20:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230446AbiBVXUL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Feb 2022 18:20:11 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C1C891350
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 15:19:44 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id p3-20020a17090a680300b001bbfb9d760eso480747pjj.2
        for <io-uring@vger.kernel.org>; Tue, 22 Feb 2022 15:19:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=2Kj0mQWQatbhtCTm+HFI2UoiTZ49oXKSoYKQY34tjbA=;
        b=6hMLrwCHV1wZvawg3er47AP/25CpXhhRcj7BgeyIAte5WgOCAm7azVgu2dvo0ydoCb
         EOAmmQzZx2UU4NhU77FHurs1f6ZyUuGHHADKF4AjBsT41FwoIoeWlTliYt0i61awet1x
         egIq9Yh5EwF/vcKpTRopbtsBPVbnzo/Y8SPwioKU0r8voTYB/iwFgUqli8BK4cmTEWuh
         we5BQFIsMkjcNQWNPD9VbVTh/jlbxDgcfpVcQUBkain88LJg9waOiaYAhzhGFlshy8I8
         K/st+Ww/jrksjNUsML4pHQOht0tVNSwQBCUZeNWWM1GaTxHHDEipVpT0+YTlwK2+b7jk
         jYkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=2Kj0mQWQatbhtCTm+HFI2UoiTZ49oXKSoYKQY34tjbA=;
        b=s7sTU53tRLgnnFXseLYrxV1FDJeetMFc8K9rruSkwhwzeM0lN2IqvvP6bLiEtP2GuZ
         PIvCgxA4zotZwddEwmlUzdyp3B8shKYvTItVxbbups8zO1Fef62qw/hU4o2gJpMyEQpM
         dpkTjyn1qQL1GKf0SzywQvpu/5uwwdwARh+PNA9Lx87zKfQVvAgfpfSxuBaKcV3W24fB
         VqoCFzcdsKCpBZnA+BpdZMINhxpolZ6xsNgWHhOCgpr0nZTkPfKrUzQmUFNoKI0LjrNC
         3SQYpSPBPbktBCsVZts1N/brn+Mp6jWnTF+c+kwKmo5nK06SS3HGTN3ITo1kee0F7HhQ
         XACg==
X-Gm-Message-State: AOAM532ER0ViDjMNaJLrXGEilWb0RgUs7jIDMtkcAa5gxupmq1dlwQHj
        OL/Zhx37ZpUcpN4N5s+s6Kbs7A==
X-Google-Smtp-Source: ABdhPJxX1LOaeb50H8NyThi6ZWQJDWsfkTNSanQ51uDyvR0uaNYIUpB+Hgr8rPcZIkX6iTlEuQoK+g==
X-Received: by 2002:a17:90b:4d0b:b0:1b9:cfb1:9cb5 with SMTP id mw11-20020a17090b4d0b00b001b9cfb19cb5mr6375514pjb.124.1645571984019;
        Tue, 22 Feb 2022 15:19:44 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id e20sm17077781pfv.42.2022.02.22.15.19.42
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Feb 2022 15:19:43 -0800 (PST)
Message-ID: <5711a265-d925-4cfd-2928-5edfb3efa954@kernel.dk>
Date:   Tue, 22 Feb 2022 16:19:41 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.0
Subject: Re: [PATCH v2 04/13] fs: split off __alloc_page_buffers function
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        Matthew Wilcox <willy@infradead.org>
Cc:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-block@vger.kernel.org,
        kernel-team@fb.com
References: <20220218195739.585044-1-shr@fb.com>
 <20220218195739.585044-5-shr@fb.com> <YhCdruAyTmLyVp8z@infradead.org>
 <YhHCVnTYNPrtbu08@casper.infradead.org> <YhScWzgGVyeaufvU@infradead.org>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <YhScWzgGVyeaufvU@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/22/22 1:18 AM, Christoph Hellwig wrote:
> On Sun, Feb 20, 2022 at 04:23:50AM +0000, Matthew Wilcox wrote:
>> On Fri, Feb 18, 2022 at 11:35:10PM -0800, Christoph Hellwig wrote:
>>> Err, hell no.  Please do not add any new functionality to the legacy
>>> buffer head code.  If you want new features do that on the
>>> non-bufferhead iomap code path only please.
>>
>> I think "first convert the block device code from buffer_heads to iomap"
>> might be a bit much of a prerequisite.  I think running ext4 on top of a
>> block device still requires buffer_heads, for example (I tried to convert
>> the block device to use mpage in order to avoid creating buffer_heads
>> when possible, and ext4 stopped working.  I didn't try too hard to debug
>> it as it was a bit of a distraction at the time).
> 
> Oh, I did not spot the users here is the block device.  Which is
> really weird, why would anyone do buffered writes to a block devices?
> Doing so is a bit of a data integrity nightmare.
> 
> Can we please develop this feature for iomap based file systems first,
> and if by then a use case for block devices arises I'll see what we
> can do there.

The original plan wasn't to develop bdev async writes as a separate
useful feature, but rather to do it as a first step to both become
acquainted with the code base and solve some of the common issues for
both.

The fact that we need to touch buffer_heads for the bdev path is
annoying, and something that I'd very much rather just avoid. And
converting bdev to iomap first is a waste of time, exactly because it's
not a separately useful feature.

Hence I think we'll change gears here and start with iomap and XFS
instead.

> I've been planning to get the block device code to stop using
> buffer_heads by default, but taking them into account if used by a
> legacy buffer_head user anyway.

That would indeed be great, and to be honest, the current code for bdev
read/write doesn't make much sense outside of from a historical point of
view.

-- 
Jens Axboe

