Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA1A5339923
	for <lists+io-uring@lfdr.de>; Fri, 12 Mar 2021 22:36:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235261AbhCLVgE (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 12 Mar 2021 16:36:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235269AbhCLVgC (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 12 Mar 2021 16:36:02 -0500
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D61FCC061574
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:36:01 -0800 (PST)
Received: by mail-pj1-x102c.google.com with SMTP id ha17so5021702pjb.2
        for <io-uring@vger.kernel.org>; Fri, 12 Mar 2021 13:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=3bPwwTEV6w0JIjXteZj2li1uDfaJ0jCCfRRCsLoqcBk=;
        b=dPJaUBn405k26Ezp2G6LxzHWbyBn0/cBq7oGPM7eZELZzdmQVCLYxmy1Uwfwa4OCvq
         Dme5L+nBEEeN0B+679GRyzDuuX6ABqAwi4+wDQl6zhAm1OXLyuarWS5IwAMV21ZJ8JB5
         bLGSNIswI0cQivEKTD9HITrDuuKVvTSwcAhyLM050eEyX1X78L86jpgI/BOC3h2pdDU4
         w63MkLnNU3oudPEqILMnXqr7HKqTow82NvBAvak6c5T2wARmMv5ShsW3jW6hdMX2b0y0
         aZU0zpXfnteyUly9ZnWBOh7dpjc7LcvYPWV0+nwwgmLg5735q8MT6/6zUjoOyPGCje65
         v2lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=3bPwwTEV6w0JIjXteZj2li1uDfaJ0jCCfRRCsLoqcBk=;
        b=q2tJIgNZXZkXueVUaBL6EXfB3j1ZVgmfqwitQ533v3ZtsOcKdKYRTox3jbelsRN+sE
         SF8MoXwvfoob272u64VQURsNt2bL0mqh+bP6Kayg/rbZAuf7GCbWISC2dGmg+zp/xGOB
         kNi5JajPD3sZt72OkC0j7wyguSsvLNzq6RfAkNGyyy+h6s5JBmaD816Y1AZOUo3fhn8+
         ejlfdoYSBLzCEz6jxIJ8thRG+qxciU6tpi0XNJTzBf25R2ccGQoOfMxBDfGIuMm+GddA
         gcWBvf7/T1MzS7sewfyV7mjpr9ipOAomx5ydhGl3wBjoESDTLOWNKIxRlUhWh1Rt4YH+
         cFCg==
X-Gm-Message-State: AOAM533VM//KZp0TilXcbW7Tu2GvtY/fyWoiC+HGxg21DrMpxKrJCvjN
        dmY3954Tp6iRdFf97buGh6ny4sjIar0KqQ==
X-Google-Smtp-Source: ABdhPJzM2acrsyKA0e8BGdWZWmWo2SAutFrrZhxy52spcrNBY+KgESbb8w8Ls+fxqLRDFLKGvkY4qg==
X-Received: by 2002:a17:90b:d85:: with SMTP id bg5mr280909pjb.230.1615584961230;
        Fri, 12 Mar 2021 13:36:01 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id z22sm6295922pfa.41.2021.03.12.13.36.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Mar 2021 13:36:00 -0800 (PST)
Subject: Re: [GIT PULL] io_uring fixes for 5.12-rc3
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     io-uring <io-uring@vger.kernel.org>
References: <a5447498-4a4c-20b3-ed1a-68b61df8b26b@kernel.dk>
 <CAHk-=wjpS-kwozJQFNBestco=q5j3bcfXpVXc6uz=9_mmQ7oYg@mail.gmail.com>
 <CAHk-=wj3gu-1djZ-YPGeUNwpsQzbCYGO2j1k_Hf1zO+z5VjSpA@mail.gmail.com>
 <CAHk-=wgzegccwzCv77fU5migNKv0GqG6fU9z8oq5GOXOS8w_Dg@mail.gmail.com>
 <CAHk-=wiNcvKE8QbP1x08F_SfjnnehehUyak8bZryxJt=EcL7Mw@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <b67df4c8-87ce-904b-03ad-a76267fb63f8@kernel.dk>
Date:   Fri, 12 Mar 2021 14:35:59 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=wiNcvKE8QbP1x08F_SfjnnehehUyak8bZryxJt=EcL7Mw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/12/21 2:34 PM, Linus Torvalds wrote:
> On Fri, Mar 12, 2021 at 1:25 PM Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>>
>> Note: I've pulled your tree, I just want you to dig deeper, verify,
>> and check this for perhaps re-instating freezability.
> 
> Also note that I don't think it's _just_ that freeze_task() thing that
> is needed for the fix.
> 
> I think the io_uring threads then need to do the whole
> "try_to_freeze()" dance in the main loop or something, so that it does
> actually freeze.

Right, and they did before the change. The freezing did work, the thaw
just left us with that sigpending and caused the never-scheduler busy
behavior. But I'll unify it all when the thawing is sorted (which I
think it is), and then enable it for all three types.

-- 
Jens Axboe

