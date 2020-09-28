Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E99B27AF23
	for <lists+io-uring@lfdr.de>; Mon, 28 Sep 2020 15:35:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726409AbgI1NfI (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 28 Sep 2020 09:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726406AbgI1NfI (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 28 Sep 2020 09:35:08 -0400
Received: from mail-io1-xd44.google.com (mail-io1-xd44.google.com [IPv6:2607:f8b0:4864:20::d44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 390CBC061755
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 06:35:08 -0700 (PDT)
Received: by mail-io1-xd44.google.com with SMTP id r25so1136332ioj.0
        for <io-uring@vger.kernel.org>; Mon, 28 Sep 2020 06:35:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NN6RqFAPLeae+jgy43hPXM6Ii+AqWHYkPLQ8G9gWDFM=;
        b=GccFP5HwTIwwgpJsDykAPJxwFC4CI2ULgm8k/mJDrI0Z5V1gMvfRDgK8tillIMBlZR
         gBUHCd9IhRGY/LL3plIRol2jL32aefDEfrwkYcDzbfCK76Q6SWXZhrqiFcDUSerAW9K1
         XKN8munfG2zO00bVh+mO0A4dWdWtQfBCElmpZrGXGczBeMzF1wJT+C4WhaYq1yr2gUbD
         HE+ZynkZOfIPZfgA7lPa4KBaFJ064CK75cE+o30uHngCQtSAMAhQMY+mFAUkEUd9D3oK
         33NSqs13p4eSEShV/ygm352dbddqNhpLOHJqxFOAVXn2+zioo01pXKDi7NL1QFt8yt+D
         f6uQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NN6RqFAPLeae+jgy43hPXM6Ii+AqWHYkPLQ8G9gWDFM=;
        b=nbko0vUYercM0/Tm3ldYq8oltHwLFPN9ijo4ZY5BcaCxB1fHwCsL/q2qDAAxY9yfyh
         1Ktw+vkFBfo4k+qn4f0hJYOIBL1ugXrjKBePMB4PaoFnfTXjX1qKhHu5oZTb3HkfVriA
         8a+X6HzGBvvD7wrd3IzClwIuTLUXBDY0QK/QrtC/MZrGoeJUyiNNzujXPcfp7XeaXg7e
         LwiDqSN6xtnFZgUKxHNykOPH2Lycq2HMK+5vpIlATLnGKVyLJD2JnojfMU4+cXYIp9zt
         Ik7FpkKeMvjlX8sBt+T14RzojpGwbZFBFEDvdP+xuJ7i5AbMrwDfzc+vPdivjOtgjCqZ
         +T/g==
X-Gm-Message-State: AOAM531fgFFbqdASIcqMmsXT7k5XAdC/q5+GZMUb3hkunkCfUByMW/rV
        uexDpWXU4CmkVfNUEdxsXmba2HnxJGRO5w==
X-Google-Smtp-Source: ABdhPJxgJo55Nna84iP2d3kSlnbyE6eKrWyLZXFeX+VSZ3/M7dg8HSuRDtOWQsKA19+XqwPi53rAHA==
X-Received: by 2002:a05:6638:3f2:: with SMTP id s18mr1257265jaq.26.1601300107240;
        Mon, 28 Sep 2020 06:35:07 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id g6sm405755iop.24.2020.09.28.06.35.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2020 06:35:06 -0700 (PDT)
Subject: Re: [PATCH 0/2] ->flush() fixes
To:     Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <cover.1601293611.git.asml.silence@gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e08aa4b7-cee1-b622-1609-ca5b4c4bdf41@kernel.dk>
Date:   Mon, 28 Sep 2020 07:35:06 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <cover.1601293611.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 9/28/20 5:49 AM, Pavel Begunkov wrote:
> It might fix flush() problems reported by syzkaller, but I haven't
> verified it. Jens, please tell if there was a good reason to have
> io_sq_thread_stop() in io_uring_flush().

No, it's not needed.

-- 
Jens Axboe

