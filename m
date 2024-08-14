Return-Path: <io-uring+bounces-2759-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E8410951108
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 02:31:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 10F4E1C20BF4
	for <lists+io-uring@lfdr.de>; Wed, 14 Aug 2024 00:31:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBADD19E;
	Wed, 14 Aug 2024 00:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="btao4+qm"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 110AE197
	for <io-uring@vger.kernel.org>; Wed, 14 Aug 2024 00:31:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723595474; cv=none; b=VE9+f9lMLoNlqXKf5MXV5jZJsNTC0L1Ui1AEAE+Qkp1UUPAG2P8BTA4ph4VkgpURZ86TRCh+8NKmTFgZxu9wlH8S9P1Y6Bo7vg2kf3xJyI6wFGrf/k6siQNZkhx/lbMI0LTNMP6kVjYXp05y6JZDWTEcQNhRZs5Xk17veBRnIwg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723595474; c=relaxed/simple;
	bh=2Wy0zZxtVHlaJs4ePhfjMZJYe0RIMLnmfzgEnhTuzss=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=hIztsS1tKO07/EQXhzNrY1kR/iRCZNG9HZI00QhqYtb+kqAAVO9FqtgGMKzhTKjY27QwCf92JvUZtiBZiSlUWtp7j016s0wm4Ml133TL/TtXGeIjyv3848uVDsrXT/zoKGHpTTJGGpVJ3j93p2acMHqQqVzr28TJw9u9PLd4AXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=btao4+qm; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2cb77ecd7a2so1119981a91.1
        for <io-uring@vger.kernel.org>; Tue, 13 Aug 2024 17:31:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1723595470; x=1724200270; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AQbtvTSoIC70UPekZsDo/+HSOt+9e2i5S/q1C6WHWcI=;
        b=btao4+qm9xApbzaF7c4RNbc8QQE0ah8fZL/j2dXdhq0I7QZQ3UuMAbKOKEkpF4F4Ik
         OHdoQVC+Kbit666UxsosjWSghi8BmQIku8KL850OE4mSqI6Me2q35ExQb5Q6QX9QWODQ
         ObLT5CHSLhUPDcYymDMTVN6CDm8VMcmsVcZOBW8SmCaezHxnoO+SDRxH4r/WCauMnScv
         XMlViY8vXAHvl+V+g3dBDBT4x/xMKAB25R2PTaCffIBfSBZBv1cPlmZ3i75i3emPUKFC
         /fkTXumPJvbKsfRWsybOZWIM78KVUG0JEPzL7i8/d6ERSNVO+mwhYBRFDnwkhQVBNQ4r
         QbgA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723595470; x=1724200270;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=AQbtvTSoIC70UPekZsDo/+HSOt+9e2i5S/q1C6WHWcI=;
        b=Y3shEtSSHSI51FtWWNaKoeq1AA+k/UHRdD2m4Ho3FSDCcTX8BxiSWkJfbh6rL7vwo9
         KaEGwZwHiNtlswo+TJ48Zk25T0LWe36ySCWA8vQu+bn8WUkbLywjfT9RI7rQGNfghSsS
         TCEWp7UZ6/WOmQ3mEvWEcA8COxG6e/djeUpddcd/MKTF6TE6sHPukdHGNCPv43dQ2foL
         pGl4GTQ1fHxA6c8PvF3zC6CXfklIILM3LHf0LuW19oXsByBpgAF12iKQWKxoi0zkR+OP
         J17FVoswHBhmDYwBvcleeJ60MhNQZHSYvz15A9RBhFvIMiguzRsChX13MYsqaZ4Z493U
         U8sg==
X-Forwarded-Encrypted: i=1; AJvYcCUQks+idKQIVMi439j6aYYHVpx/ZfP+xh/Z30ffDn7LVfhZAWMB89rDjKopNGlFcbF36UbrYZqSwQ==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxfhti2k6NoBggYz8IjEm73CrdUB+QQGMAH3KwsArBIgUNyjebO
	5U8ktNfHhZEXht3hXu5m0LHSdqti0HTGtrLN2Iewrqb7NFuqxgxSlRZKE7/itR/LCdXhQuoSDdG
	8
X-Google-Smtp-Source: AGHT+IHF2117JhxqVeOyCpsaIzyCYag/1b3QqjueeArbgjzXCENKGouSFX0PUk9N7vyJcnxVem1kRQ==
X-Received: by 2002:a17:90b:3cb:b0:2d0:1abe:5e53 with SMTP id 98e67ed59e1d1-2d3aa88b218mr816966a91.0.1723595469953;
        Tue, 13 Aug 2024 17:31:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2d3ac7dcf81sm206453a91.16.2024.08.13.17.31.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Aug 2024 17:31:09 -0700 (PDT)
Message-ID: <ff475d82-0c2e-4200-a7ef-77a074218899@kernel.dk>
Date: Tue, 13 Aug 2024 18:31:08 -0600
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] io_uring/napi: remove duplicate io_napi_entry timeout
 assignation
To: Olivier Langlois <olivier@trillion01.com>,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <145b54ff179f87609e20dffaf5563c07cdbcad1a.1723423275.git.olivier@trillion01.com>
 <05255cc5136254574b884b5e10aae7cf8301662a.camel@trillion01.com>
 <8c1ee6ab-8425-4d13-80f5-ff085d12dc91@kernel.dk>
 <f1397b51-8d41-4f91-aa25-37f771fe4e13@kernel.dk>
 <8887f2d97c1dafb6ceaf9f5c492457f642f532dd.camel@trillion01.com>
 <5730c0c1-73cb-42b5-8af3-afe60529f57d@kernel.dk>
 <e7e8a80ffcca7b3527b74be5741c927937517291.camel@trillion01.com>
 <bea51c28-17e0-4693-96bf-502ffa75f01a@kernel.dk>
 <a01899e4b4e6f83f5d191a1a26615655d97a4718.camel@trillion01.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <a01899e4b4e6f83f5d191a1a26615655d97a4718.camel@trillion01.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/13/24 6:09 PM, Olivier Langlois wrote:
> On Tue, 2024-08-13 at 12:35 -0600, Jens Axboe wrote:
>> On 8/13/24 11:22 AM, Olivier Langlois wrote:
>>> On Mon, 2024-08-12 at 14:40 -0600, Jens Axboe wrote:
>>>>
>>>>
>>>>> 3. I am surprised to notice that in __io_napi_do_busy_loop(),
>>>>> list_for_each_entry_rcu() is called to traverse the list but
>>>>> the
>>>>> regular methods list_del() and list_add_tail() are called to
>>>>> update
>>>>> the
>>>>> list instead of their RCU variant.
>>>>
>>>> Should all just use rcu variants.
>>>>
>>>> Here's a mashup of the changes. Would be great if you can test -
>>>> I'll
>>>> do
>>>> some too, but always good with more than one person testing as it
>>>> tends
>>>> to hit more cases.
>>>>
>>> Jens,
>>>
>>> I have integrated our RCU corrections into
>>> https://lore.kernel.org/io-uring/5fc9dd07e48a7178f547ed1b2aaa0814607fa246.1723567469.git.olivier@trillion01.com/T/#u
>>>
>>> and my testing so far is not showing any problems...
>>> but I have a very static setup...
>>> I had no issues too without the corrections...
>>
>> Thanks for testing, but regardless of whether that series would go in
>> or
>> not, I think those rcu changes should be done separately and upfront
>> rather than be integrated with other changes.
>>
> sorry about that...
> 
> I am going to share a little bit how I currently feel. I feel
> disappointed because when I reread your initial reply, I have not been
> able to spot a single positive thing said about my proposal despite
> that I have prealably tested the water concerning my idea and the big
> lines about how I was planning to design it. All, I have been told from
> Pavel that the idea was so great that he was even currently playing
> with a prototype around the same concept:
> https://lore.kernel.org/io-uring/1be64672f22be44fbe1540053427d978c0224dfc.camel@trillion01.com/T/#mc7271764641f9c810ea5438ed3dc0662fbc08cb6

Sorry if I made you feel like that, was not my intent. I just latched on
to the ops setup and didn't like that at all. I do think
pre-registrering an ID upfront is a good change, as it avoids a bunch of
hot path checking. And for a lot of use cases, single NAPI instance per
ring is indeed the common use case, by far.

Please realize that I get (and answer) a lot of email and also have a
lot of other things on my plate than answer emails, hence replies can
often be short and to the point. If I don't mention a part of your
patch, I either missed it or figured it necessitated a rework based on
the other feedback.

> you also have to understand that all the small napi issues that I have
> fixed this week are no stranger from me working on this new idea. The
> RCU issues that I have reported back have been spotted when I was doing
> my final code review before testing my patch before submitting it.
> 
> keep in mind that I am by far a git magician. I am a very casual
> user... Anything that is outside the usual beaten trails such as
> reordoring commits or breaking them down feels perilious to me...

Reviews and fixes are _always_ appreciated, even if emails don't include
that. They sure could, but then it'd just be a copied blurb, and I don't
think that's very genuine. FWIW, your patch submissions have been fine.
The critique I had for your patch was that you should not include little
fixes with larger changes. That's just not how kernel patches are done.
You do the little fixes first, and then the bigger change on top as
separate changes. The reason for that are two-fold: it makes it easier
to backport them to stable, if that is needed, and it makes it easier to
review the actual functional change. Both of those are really important.

> I had 230+ lines changes committed when you confirmed that few lines
> should be changed to address this new RCU issue. I did figure that it
> would not that big a deal to include them with the rest of my change.

See above, it is a big deal, and honestly something I recommend for any
kind of project, not just the kernel.

> that being said, if my patch submission is acceptable conditional to
> needed rework, I am willing to learn how to better use git to meet your
> requirements.

Your git skills are fine, don't worry about that, there's nothing wrong
with the mechanics of the submission. It's just the changes themselves
that need a splitting up, and rework.

-- 
Jens Axboe


