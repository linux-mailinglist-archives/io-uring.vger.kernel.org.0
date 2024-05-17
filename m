Return-Path: <io-uring+bounces-1917-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id BBD918C8B1C
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 19:37:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 4BB3D1F21BE6
	for <lists+io-uring@lfdr.de>; Fri, 17 May 2024 17:37:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F6D713E040;
	Fri, 17 May 2024 17:36:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="emn3CkST"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B50213E028;
	Fri, 17 May 2024 17:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715967401; cv=none; b=VGD+W1XxUso2VlvuOvz4lxOKEOG1+CgMdYH21RRFwrGzncpE6uX2rvfoTeeEHPH29OY+v7d//yMlX7Zpm1LmdWg/0Q0Ow6NTNHQM5w2kDcyPbB/vgn1f05c54oSM9ndNq8DwMOIyRgbeC12qwPOBes4JNFpurb5I1nclEbQAOg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715967401; c=relaxed/simple;
	bh=l7K75G8hEZf6Nf3Gd+zb5LouEwarRLauIdJPMoFivlA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=HHDU2a+DAWtPRcmt4C6PNdPbseXKcMelAX2wzvQMYCRqxHPakEdRVvQff3WPguwpodBLpV7fPbdCvZ94NfW0WSvQDuc0Gmbi/M37I2hQcmH6pFp7wlAmn5n+co7hQSDkGkpVMKwa0McBxDQvO/xYNevxFiLG7sf4OWnflrwmeZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=emn3CkST; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-1ee954e0aa6so16680785ad.3;
        Fri, 17 May 2024 10:36:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1715967399; x=1716572199; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rzMfxbAB8QJEcJdIySGROcUOqAKXWq8nqUdcExbi1Zk=;
        b=emn3CkSTmGwb7Ev6REZ9Z3U3XD4Y+jPjdTTKRrd1xunPWgI+cGM6iP3TELOI5V8ATa
         VbiGe+xcAirEDS5iorMu2B+VEBPivgYYBJAFyyk/dtcE+BdDAEcBR/OSDeMAia+M02aV
         JtJr53ZjOlMBaf51DPBBJSXIlVEj8/ta7pTQaBfTGVSwemtnu9tMYnJUuHNl2FkBsWa2
         RY29x4C0oql3h5xd/BScqyiM9KMAjCxcwhA5cszmGMdkeAyAQyWwOl4SEGtmK+Cfk17e
         ZUmUwjzXpEuOreMImVvNFBtQTMD0YnZzxGLGWYMvA88gK3n/MpOcCwIl6WzZ4yooz3JS
         JzXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715967399; x=1716572199;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rzMfxbAB8QJEcJdIySGROcUOqAKXWq8nqUdcExbi1Zk=;
        b=tRaBInC5CBZVJiTyNhPeAMF0Mv8ZyhDngT/Ke4lsBz6dnWLTVbrxiYmDGKR3474tHa
         Jw0S2Pd1w9vB5TttyIKUZ3vkElFqN8D82iwb6kL7vCXbWz+ZO+kOgSp2q2lMeYG13wJ3
         Pd4jLhwNb/5j//D5V0kA6eEHTeRPM+KlHNN2ZXDOKj2sqnyMigDYM3Yyxzog0n99DW50
         DbdwYUgj+mBGDnl1Wi3MfB/KObA9dlYM5hJ0VYDOGEqfhhsM9xkE6J3r09MMgCufkcSJ
         MFPDLIL9Qyg8pNl52R6ymP0RQyefKT1UiQ+E7Y0jutAqKo/SZ6YeNcoI1ileC9aAa4W0
         uyJQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeikZ+5A7mGmqeVlRxUOHe3Z4BVx7A6SdRIJ9KlcdOS9QSNvCDsre7aHGEDTt/hTkAM3qO0uM2xeP+jtEHZh5JsSeK9A/+tFrYQA1Gt+sOL3ewNO6LlYK9y7DD7mpAtqpfD7DjXB75ufvKHVU6kM3a/elOuYDfutBUvo4a9bI4BCb2VDcyzEXzDexUc9t0in/T8C2XOhPKn7wWpdtpjhPEZSUvfBbj5JIuV5SOt4ozapoAEBa6p9eoNzUqVSV+FTR0IAeRERSnOL6XqGk495fk7J/QsGArESB7IkyWGLl2UfJVr+STIxS8eHdJJiLcNAzso4UUQBPch6E8dfNENIPvXxQAsave+ZjX9aqXjIT96Hz/aHminfcbngd99gozkR8JcHcG37i5SZidszxbbVcf9ugBd6iBJBSvP3YPM6hIvwhrKlXpceN2VyhqUDGta0Y2tQ8Y92YBThBW9tUwaEcwpwLLtnkcoENUdMSzNo1PisKVaRS0s0oNoAWHaeTm033idWAzW8Z6AMcGqpdUZef30iZpnny7DOCCRdx6bdPIPfc8m8lwMbo6DXkdKIQnaqlplZsK6CLKNgppIYSJ7U793bTJTH44UOdcWLKNUTDeK1XJMU+un4iEAjTM4sbk5xfiplNYftumz3+FD+ZUcLZWXKJBMvMx7eT5NA18jT46CIW4oBwdkZsngjutYGEYxbL/3oE5mRVrHB1dgdQB0YljgIrh2vfVWMnSdGUfmhbsUn3exZybXMRR9PJNk7TMh60ZKjaGM3YyEgvEgQVWpZ4sxK1fHIUzkaJHi56sH9Vb1HRQuX6pNOHreK/nEi3g6aW7gIA7T1ww4N6bLeNtZRSJMBfQ7RJIfpa4nB66EJI9p+xXnabbY1FucmTW2fAhf83tzqzRTLEML3+RBqx6xPn5uR2l/K2m0V/YFHhfHKN5kNYIOcc0Y+KpHUPL2A==
X-Gm-Message-State: AOJu0YyVJKJDHI54++5KLrCtRmLug9WO1yHYT9xtbae1yHeJBFY7OAOO
	4meyTffhXTst2nI7rjVckVaPWZ7pOCdtS8zLnwvw9MCn/zh6jfsS
X-Google-Smtp-Source: AGHT+IHJ9PZtASiLb9HJkYrHy1DRhdQlVEuKbRr0NYIRv4Tx+av91BIA0wx1gBcIQQlm9sd2COIQnQ==
X-Received: by 2002:a17:90a:9606:b0:2b9:a299:928e with SMTP id 98e67ed59e1d1-2b9a29994c9mr10436893a91.24.1715967398710;
        Fri, 17 May 2024 10:36:38 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2b67105666csm15749258a91.8.2024.05.17.10.36.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 May 2024 10:36:38 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Fri, 17 May 2024 10:36:37 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
	Linux trace kernel <linux-trace-kernel@vger.kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org,
	linux-block@vger.kernel.org, linux-cxl@vger.kernel.org,
	linux-media@vger.kernel.org, dri-devel@lists.freedesktop.org,
	amd-gfx@lists.freedesktop.org, intel-gfx@lists.freedesktop.org,
	intel-xe@lists.freedesktop.org, linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org, virtualization@lists.linux.dev,
	linux-rdma@vger.kernel.org, linux-pm@vger.kernel.org,
	iommu@lists.linux.dev, linux-tegra@vger.kernel.org,
	netdev@vger.kernel.org, linux-hyperv@vger.kernel.org,
	ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
	ath11k@lists.infradead.org, ath12k@lists.infradead.org,
	brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com,
	linux-usb@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	linux-nfs@vger.kernel.org, ocfs2-devel@lists.linux.dev,
	linux-cifs@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-edac@vger.kernel.org, selinux@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-erofs@lists.ozlabs.org,
	linux-f2fs-devel@lists.sourceforge.net, linux-hwmon@vger.kernel.org,
	io-uring@vger.kernel.org, linux-sound@vger.kernel.org,
	bpf@vger.kernel.org, linux-wpan@vger.kernel.org,
	dev@openvswitch.org, linux-s390@vger.kernel.org,
	tipc-discussion@lists.sourceforge.net,
	Julia Lawall <Julia.Lawall@inria.fr>
Subject: Re: [PATCH] tracing/treewide: Remove second parameter of
 __assign_str()
Message-ID: <5080f4c5-e0b3-4c2e-9732-f673d7e6ca66@roeck-us.net>
References: <20240516133454.681ba6a0@rorschach.local.home>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240516133454.681ba6a0@rorschach.local.home>

On Thu, May 16, 2024 at 01:34:54PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Google)" <rostedt@goodmis.org>
> 
> [
>    This is a treewide change. I will likely re-create this patch again in
>    the second week of the merge window of v6.10 and submit it then. Hoping
>    to keep the conflicts that it will cause to a minimum.
> ]
> 
> With the rework of how the __string() handles dynamic strings where it
> saves off the source string in field in the helper structure[1], the
> assignment of that value to the trace event field is stored in the helper
> value and does not need to be passed in again.
> 
> This means that with:
> 
>   __string(field, mystring)
> 
> Which use to be assigned with __assign_str(field, mystring), no longer
> needs the second parameter and it is unused. With this, __assign_str()
> will now only get a single parameter.
> 
> There's over 700 users of __assign_str() and because coccinelle does not
> handle the TRACE_EVENT() macro I ended up using the following sed script:
> 
>   git grep -l __assign_str | while read a ; do
>       sed -e 's/\(__assign_str([^,]*[^ ,]\) *,[^;]*/\1)/' $a > /tmp/test-file;
>       mv /tmp/test-file $a;
>   done
> 
> I then searched for __assign_str() that did not end with ';' as those
> were multi line assignments that the sed script above would fail to catch.
> 

Building csky:allmodconfig (and others) ... failed
--------------
Error log:
In file included from include/trace/trace_events.h:419,
                 from include/trace/define_trace.h:102,
                 from drivers/cxl/core/trace.h:737,
                 from drivers/cxl/core/trace.c:8:
drivers/cxl/core/./trace.h:383:1: error: macro "__assign_str" passed 2 arguments, but takes just 1

This is with the patch applied on top of v6.9-8410-gff2632d7d08e.
So far that seems to be the only build failure.
Introduced with commit 6aec00139d3a8 ("cxl/core: Add region info to
cxl_general_media and cxl_dram events"). Guess we'll see more of those
towards the end of the commit window.

Guenter

