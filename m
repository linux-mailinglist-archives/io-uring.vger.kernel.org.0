Return-Path: <io-uring+bounces-3699-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2964F99FC88
	for <lists+io-uring@lfdr.de>; Wed, 16 Oct 2024 01:40:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4AC2E1C245C8
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 23:40:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4BC4221E3D8;
	Tue, 15 Oct 2024 23:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="YDCXLxuH"
X-Original-To: io-uring@vger.kernel.org
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9929C1C75F9;
	Tue, 15 Oct 2024 23:40:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729035652; cv=none; b=mPW+Xp8PCaA8c3ltOCBw+ZyE1Z3CclzWGBtdrUeHVULx+bDsPnjdOB7PYSDMVmJCEyfE0U72Bt+gbPfFFI2oFbGNTtXuYU0PwHv2gsWAIf1xB+df6ivA8mr8I07dF4J1ZsPtWxksQb+ygyrhv33YqvaAthych9sOzXCTUdYH7+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729035652; c=relaxed/simple;
	bh=T7e4u99v2t/o1yhLjGkzMkZYKE8GWU/LmpLPnBVf9xs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YaCovtG28paa7g00y3F5NRl6v0VBczJ5KpL8jYUw46Md71D/66CfvF0PAGmcz5jEUVcI+NzpH9wlwcw2FKV499QqNNHUl2hchY/81v39TfIu3xyBszd1z1Do7oF1hMQPvoLZRyZADa8ZNVjxjf0gSAD9sg+9hkhxGkfLsAp5/J8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com; spf=pass smtp.mailfrom=intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=YDCXLxuH; arc=none smtp.client-ip=198.175.65.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1729035651; x=1760571651;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=T7e4u99v2t/o1yhLjGkzMkZYKE8GWU/LmpLPnBVf9xs=;
  b=YDCXLxuH2f4MHyx3WPqQX/+WKBS6LPTxCO6A6ueJNlhLUhYG4+FEnNXs
   KkhbJas8Iwq0jtejmAAxydZH4xDkU7aCZtaUZ29ZMa7oQs9H2FIovRLEZ
   mlZpU9bmM7hPH1BUK0z3RDdstEuYrAdLV2/O36jC4OsAIEA7+uy6yckw5
   DJAIJa7SSQxBQVIp8yJkKISfYgNU4NE8Rx59sd0Bpm2NvmOnjCjBlF4Rm
   Im3L0TrIoQ5W7Z8MUiWkYILnbJSvdZuTJDiP+lIrju0P/5Ogyi0qvyepb
   IVkJTWdI2xO7Yy7j1Te+k92cL+WzUrfNnUcxCQwHLCEHJ50SPN76tIOsx
   g==;
X-CSE-ConnectionGUID: mILWayW+Sve2C2WxFDwz7A==
X-CSE-MsgGUID: pPAIlgkSSh+1vatbnBKkuA==
X-IronPort-AV: E=McAfee;i="6700,10204,11222"; a="28417642"
X-IronPort-AV: E=Sophos;i="6.11,199,1725346800"; 
   d="scan'208";a="28417642"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa113.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 16:40:50 -0700
X-CSE-ConnectionGUID: NGhGJtRhR2u8IqG/dxwaIg==
X-CSE-MsgGUID: kp1WXvDfS6a7pkXsV3FfjQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.11,206,1725346800"; 
   d="scan'208";a="78892355"
Received: from mdroper-mobl2.amr.corp.intel.com (HELO [10.124.221.110]) ([10.124.221.110])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Oct 2024 16:40:48 -0700
Message-ID: <15c0859f-445f-4159-9b38-3af6d9a2a572@intel.com>
Date: Tue, 15 Oct 2024 16:40:48 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: WARNING in get_pat_info
To: Marius Fleischer <fleischermarius@gmail.com>, Jens Axboe <axboe@kernel.dk>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
 Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
 Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, linux-kernel@vger.kernel.org,
 syzkaller@googlegroups.com, harrisonmichaelgreen@gmail.com,
 Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org
References: <CAJg=8jwijTP5fre8woS4JVJQ8iUA6v+iNcsOgtj9Zfpc3obDOQ@mail.gmail.com>
 <CAJg=8jxg=hCxTeNMmtUTKeBhP=4ryoAb0ekoP05FOLjmDN5G0g@mail.gmail.com>
 <f02a96a2-9f3a-4bed-90a5-b3309eb91d94@intel.com>
 <fc3a0edc-f2fb-488a-81d9-016f78b5671d@kernel.dk>
 <CAJg=8jzfbrG+-wBz29wKKPXuPFSR_1Ltb6mmO9czh-834aN0UQ@mail.gmail.com>
From: Dave Hansen <dave.hansen@intel.com>
Content-Language: en-US
Autocrypt: addr=dave.hansen@intel.com; keydata=
 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
In-Reply-To: <CAJg=8jzfbrG+-wBz29wKKPXuPFSR_1Ltb6mmO9czh-834aN0UQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/15/24 15:29, Marius Fleischer wrote:
> Hi Jens,
> Please find the config we used for testing the reproducer on v5.15.167
> - hope that helps.
> 
> Which of the reproducers did you try? Upon more testing, it seems like the
> C reproducer (repro.c) is a little unstable on v5.15.167 but repro.syz works
> fine. Instructions on how to run repro.syz are here:
> https://github.com/google/syzkaller/blob/master/docs/executing_syzkaller_programs.md

FWIW, those instructions don't work if you don't have 'go' in your path
already.  Even when you do, it apparently needs to be a pretty recent
version.

They also say "Unpack it (a tarball) to $HOME/goroot".  I read that as:

	mkdir $HOME/goroot
	cd $HOME/goroot
	tar -zxf $TARBALL

When I think it really means something like:

	cd $HOME
	tar -zxf $TARBALL
	mv go goroot

or something.

I figured it out eventually, but it would be nice to make those
instructions a _bit_ more clear, especially for folks that don't have a
recent go toolchain already sitting around.

Oh, and the go toolchain had a jolly old time beating up on my poor
little 4GB-of-RAM test VM.  I had to double its RAM just to compile this
beast.

> TL;DR compile syzkaller, copy syz-execprog, syz-executor, repro.syz into
> the VM and run the command below inside the VM
> ./syz-execprog -executor=./syz-executor -procs=8 -repeat=0 repro.syz
> 
> Please let me know if you need more details from us!

It didn't reproduce for me, either, at least ~10k executed programs in.
How long should it take?

The next step would be to figure out specifically why get_pat_info()
failed.  To double check that io_uring is the thing that's involved and
(presumably) why follow_phys() failed.  Basically, I think we need to
know what state the page tables and the VMA were in.

