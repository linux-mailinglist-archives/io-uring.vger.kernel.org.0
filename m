Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC06A1C71FA
	for <lists+io-uring@lfdr.de>; Wed,  6 May 2020 15:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728058AbgEFNpg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 6 May 2020 09:45:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725966AbgEFNpg (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 6 May 2020 09:45:36 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B53EC061A0F
        for <io-uring@vger.kernel.org>; Wed,  6 May 2020 06:45:36 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id s8so2269679wrt.9
        for <io-uring@vger.kernel.org>; Wed, 06 May 2020 06:45:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=to:references:from:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3bSQ+b58zHUGRAxAgt3Z4F/KNvSB5vqhLF5vmymo4Vc=;
        b=GJlTtcwL1KSpui3D6b18egPSXm8nZoxVoHz5icWo9R7RRx3anOEcwmnASt6RNa3lDU
         2rOOEAWgPwVK1KMz6dE7VBfXfQaiF9+Z3fOuHM6roiicvpZEg1lv/ClhKekwc4pzkb8g
         Wo+xs8/2nRFjPbYJqKl5RDOkp9K6ZHGUEMV3EUs5jY1Ic/0tgeHEsbBFxzr5sGW2rnNj
         ZpQyZhF3leZ0hH7g/6ErDxgEJEHu6poTST7qd1Fo1AKGuAf9iKRfLZGwLWdpSIYlv2M+
         W4rUP7l/qWJJC7Bdi5ZmphbVWnIJa9UzbWpbmHBuUWFVRqxveZL5+uEwLyryYik7zsCH
         TpOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:references:from:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3bSQ+b58zHUGRAxAgt3Z4F/KNvSB5vqhLF5vmymo4Vc=;
        b=OxGZSgBFUKMEKrzx0y1o/h1U4zHLjNHDx21bbgp3gknfHLGqH/sPJ27wg7mBLrscgm
         qJe/Xysl3QVwgue864ltef+upxnKpUK0t+sgZg+ZGk2DMkWAgyV9R0yTkLd9NATT0CVY
         EVzQiRjPV8rUk7EtKbc+ZYmhmCULvRN93ebv3U9zcXo5BUEHIHLF/6WAh4c2ShcXwhwC
         nng2WZDQYHyBWlQuBNyyUbSlu1BzgkVb/uP0ZrgNV5ELgawvswBA1YkeUhjtlCA2CwvF
         fiyHBAVOmpzHOhwPRGTjLT69RkgJK+7aTSg7nzCl4KTe0cGd3wBOMQWj9WJ74yIGIAew
         OV5g==
X-Gm-Message-State: AGi0PuaseXU9c5nawLrEK+q3eTh8n2LgH33/aKPQk5yrsyEWFeNFrSjR
        toTwl9u14EONv52XYe7Dzfr6TvzJ
X-Google-Smtp-Source: APiQypJ9/XPhsajyiLw9KHCxjfp1PvpbCUNerhxme0nphfpCj7iwS0eevO7F3aXjj3PAJo20d8lC4g==
X-Received: by 2002:adf:9286:: with SMTP id 6mr147067wrn.179.1588772734570;
        Wed, 06 May 2020 06:45:34 -0700 (PDT)
Received: from [192.168.43.168] ([109.126.133.135])
        by smtp.gmail.com with ESMTPSA id 17sm3000221wmo.2.2020.05.06.06.45.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 06:45:34 -0700 (PDT)
To:     Lorenzo Gabriele <lorenzolespaul@gmail.com>,
        io-uring@vger.kernel.org
References: <CAC40aqaSBwdBxQOn1T_ihtB=TnNLH91_xy05gFhvOG+3i3=ang@mail.gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: are volatile and memory barriers necessary for single threaded
 code?
Message-ID: <32cf6f07-c2df-76ed-5200-c39821cf6f61@gmail.com>
Date:   Wed, 6 May 2020 16:44:25 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <CAC40aqaSBwdBxQOn1T_ihtB=TnNLH91_xy05gFhvOG+3i3=ang@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 04/05/2020 19:54, Lorenzo Gabriele wrote:
> Hi everyone,
> I'm a complete noob so sorry if I'm saying something stupid.
> I want to have a liburing-like library for the Scala Native language.
> I can't easily use liburing itself because of some limitations of the
> language.. So I was rewriting the C code in liburing in Scala Native.
> The language is single threaded and, sadly, doesn't support atomic,
> nor volatile. I was thinking what are the implications of completely
> removing the memory barriers.
> Are they needed for something related with multithreading or they are
> needed regardless to utilize io_uring?

Long story short, even if your app is single-threaded, io_uring is _not_.
I wouldn't recommend removing it. See the comment below picked from io_uring.h

/*
 * After the application reads the CQ ring tail, it must use an
 * appropriate smp_rmb() to pair with the smp_wmb() the kernel uses
 * before writing the tail (using smp_load_acquire to read the tail will
 * do). It also needs a smp_mb() before updating CQ head (ordering the
 * entry load(s) with the head store), pairing with an implicit barrier
 * through a control-dependency in io_get_cqring (smp_store_release to
 * store head will do). Failure to do so could lead to reading invalid
 * CQ entries.
 */


More difficult to say, what will actually happen. E.g. if you don't use polling
io_uring modes, and if you don't do speculative CQ reaping, there is a pairing
smp_rmb() just before returning from a wait. But, again, the io_uring ABI
doesn't guarantee correctness without them.

-- 
Pavel Begunkov
