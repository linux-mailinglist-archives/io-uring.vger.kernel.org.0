Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7D5E3F4E19
	for <lists+io-uring@lfdr.de>; Mon, 23 Aug 2021 18:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229667AbhHWQP3 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 23 Aug 2021 12:15:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229962AbhHWQP1 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 23 Aug 2021 12:15:27 -0400
Received: from mail-ot1-x333.google.com (mail-ot1-x333.google.com [IPv6:2607:f8b0:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9081CC061575
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 09:14:44 -0700 (PDT)
Received: by mail-ot1-x333.google.com with SMTP id i8-20020a056830402800b0051afc3e373aso26458484ots.5
        for <io-uring@vger.kernel.org>; Mon, 23 Aug 2021 09:14:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Y/fJEiw7QUkBCfFPAmE/s89Bl6kM76DPzpSL413KbHQ=;
        b=IR1MV9tciq9IZtu2+3aShnJFlpmSUOLjDpMdppSoxQlFDt2OcqbPjO0lFgJqdW7fcK
         EdpGe2xKKgmetth1ELG/iq8D+1VADERxON9kXrUtLfTT+WeVID/Cu9zmuJHou7k3pCW+
         g/emkwBYgu6r1oYeJAWr+rm+7r8vW6DA8nbkxMWHhGVM9jSmM/CPjH3YUYwnOeyT7/ZW
         yAVzfBp5au/kl29Vcs0Fj6mqV04mL+JFa1je/6YH6i01aDj+iEh6c3f4Lw+Wi0A/PMqi
         sl/WnB98d67eNJgJt5tTS1Y9mHzXMtBCOTVO0Rex6POeaI3Z9YGZ4Xu2HveqFl9SbFFE
         EAaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Y/fJEiw7QUkBCfFPAmE/s89Bl6kM76DPzpSL413KbHQ=;
        b=XFTqpGA0WNRj8ctFXJBeqrACwyWeBkhEoCro6LeU/OvNG+9BXqTiZsPeNZ6CIwGg17
         2esMMRbwW/k7RUYBQs6F81gf004TAEMV/FGoOPrCLfwqg9IMZC3uYQttzGd5EnxHSCiB
         mtzywkaE0zB4qlRmhTlG/Z6gwnN5n/ArlB7GzkoKs+lbj/VtQboL/9nhqukmyOmzZDVG
         eAjbR5lCUdNiBafRjZIMNHr8Y5WKctRgUSCI2AdBOpDjTu7byaT0mVl/ZkygEFsuy12D
         G67NdONJia1gdSqe2YDCZ38J+ij8VU+LiPgSlws7Iw3C9TnkHygDZzSgFwaaYTJmYxgV
         LhHQ==
X-Gm-Message-State: AOAM531RDnIX8a2NCnrrjfleQTVb7uOC2uMrcdkjxSCIJcPm52gsywAM
        E1CdizRkreBTCrHn11WXwxdzfQ==
X-Google-Smtp-Source: ABdhPJyaIfANEkTwh2OuOQkhwomq1hHuelv90C4jPycrt3AcKsiYkfW5OlCqOrfENiNPwAmn3Dd4kQ==
X-Received: by 2002:a05:6830:1056:: with SMTP id b22mr27833693otp.325.1629735283951;
        Mon, 23 Aug 2021 09:14:43 -0700 (PDT)
Received: from [192.168.1.30] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id b9sm3964472otp.46.2021.08.23.09.14.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Aug 2021 09:14:43 -0700 (PDT)
Subject: Re: [PATCH v3 0/2] iter revert problems
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Cc:     Palash Oswal <oswalpalash@gmail.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>,
        linux-kernel@vger.kernel.org,
        syzbot+9671693590ef5aad8953@syzkaller.appspotmail.com
References: <cover.1629713020.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <2a981061-5420-85dd-d41c-7ed36384465c@kernel.dk>
Date:   Mon, 23 Aug 2021 10:14:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1629713020.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/23/21 4:18 AM, Pavel Begunkov wrote:
> iov_iter_revert() doesn't go well with iov_iter_truncate() in all
> cases, see 2/2 for the bug description. As mentioned there the current
> problems is because of generic_write_checks(), but there was also a
> similar case fixed in 5.12, which should have been triggerable by normal
> write(2)/read(2) and others.
> 
> It may be better to enforce reexpands as a long term solution, but for
> now this patchset is quickier and easier to backport.

Al, given the discussion from this weekend, are you fine with the first
patch? If so, would be great with an ack/review. Or, if you want to
funnel this for 5.14, you can add:

Reviewed-by: Jens Axboe <axboe@kernel.dk>

-- 
Jens Axboe

