Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2491B2411C2
	for <lists+io-uring@lfdr.de>; Mon, 10 Aug 2020 22:35:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgHJUfF (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 10 Aug 2020 16:35:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726396AbgHJUfF (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 10 Aug 2020 16:35:05 -0400
Received: from mail-pj1-x1041.google.com (mail-pj1-x1041.google.com [IPv6:2607:f8b0:4864:20::1041])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 189F1C061756
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 13:35:05 -0700 (PDT)
Received: by mail-pj1-x1041.google.com with SMTP id 2so670465pjx.5
        for <io-uring@vger.kernel.org>; Mon, 10 Aug 2020 13:35:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QsTuC06CYXzeWWXz7fizzQ/gbR248GzvX/tFJrAjiaY=;
        b=BnRbEl6rkrgExnb+K8MgPrXLCirsBZ+T2w/2lopf4nX0dV1rWLQshPIme3iU57TS2S
         7knIDuoceP5Qack8RTiR5GOlnuZfdTXB42Z7P4fwo22HHTCo0s0Yj5JU/26ZYQNwsRiT
         C5Uz+baubHGYKccfeZKhhDTIeUNFCPpHNX5TEohL6Rww0grv3/iIkQhiX4UycI16m/gn
         6FCv0rgslfFFmXUlrlGsNxSivVYZseG+f9iJDl/X7CcCD9uZ8xlRrS80dnfB/R14Tnr+
         5wkxrQR520hGSa3R+TSoUG/HrqG7ZBrn0dpHsVuccyQzokdTni+kHSKVS3/7yXZhkqTg
         YO6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QsTuC06CYXzeWWXz7fizzQ/gbR248GzvX/tFJrAjiaY=;
        b=s1IFu3AtqXPjanmd1eNZHIrZANq8IL2sEKH5z39zzIsF6SS/BQYMdFNaRekECFGDhn
         gLIuRgPzNJt2tB7ZYcsKkfXQ6TAxsb9nLzxhhFd0eRb2KOgIUHYllA/WXH5cSSOdLyLh
         zazz41y1kUO12skd/vEotaqABECgvsbr/X/46GoK7PD3dUe8z6fqtpOCmM/epgkpNrLp
         YWPi92Z7dxR1XsasGNmb/pXLuAzldRs6FZ8XR3rCOVo69PXm+qrrcl2YAYK4IU9Go5to
         b1KSzwhO2Jca+fZ8STEn5+XIprkjmkrvoZp0vmAPkyk4hV3KWlQGpSEW6VuRzI9Vhtx9
         WdbQ==
X-Gm-Message-State: AOAM530gW1csSku0KgKKOptfyB/UVmhHRX6AL8i1NAKZNbJ2lX8JfvFx
        ny4v7uDLBgiFiRWSt3bkrofOkw==
X-Google-Smtp-Source: ABdhPJyVzhvKfjQjhSqu1Bs2mM2eJRJAkXMmTr+Q8j/oCnnku2fmUit11235NaoQ1/M5u7n+4uzMFg==
X-Received: by 2002:a17:90a:ea91:: with SMTP id h17mr1091791pjz.36.1597091704586;
        Mon, 10 Aug 2020 13:35:04 -0700 (PDT)
Received: from [192.168.1.182] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id u15sm18962445pgm.10.2020.08.10.13.35.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2020 13:35:03 -0700 (PDT)
Subject: Re: [PATCH 2/2] io_uring: use TWA_SIGNAL for task_work if the task
 isn't running
To:     Peter Zijlstra <peterz@infradead.org>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org,
        Josef <josef.grieb@gmail.com>, Oleg Nesterov <oleg@redhat.com>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-3-axboe@kernel.dk>
 <20200810114256.GS2674@hirez.programming.kicks-ass.net>
 <a6ee0a6d-5136-4fe9-8906-04fe6420aad9@kernel.dk>
 <07df8ab4-16a8-8537-b4fe-5438bd8110cf@kernel.dk>
 <20200810201213.GB3982@worktop.programming.kicks-ass.net>
 <4a8fa719-330f-d380-522f-15d79c74ca9a@kernel.dk>
 <faf2c2ae-834e-8fa2-12f3-ae07f8a68e14@kernel.dk>
 <20200810203240.GE3982@worktop.programming.kicks-ass.net>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <82479701-7988-1316-b24a-af35469ac3b4@kernel.dk>
Date:   Mon, 10 Aug 2020 14:35:02 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200810203240.GE3982@worktop.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 8/10/20 2:32 PM, Peter Zijlstra wrote:
> On Mon, Aug 10, 2020 at 02:25:48PM -0600, Jens Axboe wrote:
>> On 8/10/20 2:13 PM, Jens Axboe wrote:
>>>> Would it be clearer to write it like so perhaps?
>>>>
>>>> 	/*
>>>> 	 * Optimization; when the task is RUNNING we can do with a
>>>> 	 * cheaper TWA_RESUME notification because,... <reason goes
>>>> 	 * here>. Otherwise do the more expensive, but always correct
>>>> 	 * TWA_SIGNAL.
>>>> 	 */
>>>> 	if (READ_ONCE(tsk->state) == TASK_RUNNING) {
>>>> 		__task_work_notify(tsk, TWA_RESUME);
>>>> 		if (READ_ONCE(tsk->state) == TASK_RUNNING)
>>>> 			return;
>>>> 	}
>>>> 	__task_work_notify(tsk, TWA_SIGNAL);
>>>> 	wake_up_process(tsk);
>>>
>>> Yeah that is easier to read, wasn't a huge fan of the loop since it's
>>> only a single retry kind of condition. I'll adopt this suggestion,
>>> thanks!
>>
>> Re-write it a bit on top of that, just turning it into two separate
>> READ_ONCE, and added appropriate comments. For the SQPOLL case, the
>> wake_up_process() is enough, so we can clean up that if/else.
>>
>> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=49bc5c16483945982cf81b0109d7da7cd9ee55ed
> 
> OK, that works for me, thanks!
> 
> Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>

Thanks for checking (again) - I've added your acked-by.

-- 
Jens Axboe

