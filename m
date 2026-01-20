Return-Path: <io-uring+bounces-11839-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SEz8GeWub2lBGgAAu9opvQ
	(envelope-from <io-uring+bounces-11839-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:35:49 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [IPv6:2605:f480:58:1:0:1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C889F47B12
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 17:35:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 20C545E824A
	for <lists+io-uring@lfdr.de>; Tue, 20 Jan 2026 15:39:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF7AD43E48F;
	Tue, 20 Jan 2026 15:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="co/8lI/E"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7702D43E482
	for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 15:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768922385; cv=none; b=LEhmT3kYsUY9wWN1OYnp4BgUiWlqw5MfXBJcWLPZoAeLEQMMq1f9qliA3fiEx/7+BWitLob7QxUD+4uK7XF9gbo7G5rCQFhoRnPd4wgw/M1RTGRow8984CPmoVTLNr3BiYHWntopm8cEByY/zty93j7WzEjtRhbvUl7Xhm2abL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768922385; c=relaxed/simple;
	bh=xjpr46sXBhhxjVf3zoDX21QVM4JiYoaXariNkXkPWDE=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=IG/rgeK4oJ1wkKT0IoFGt7LI3lfKonvq/IW4ssFs7VrQxqJK0t5qB2ECCtsUDQJK0Itea/D2KPgmzeZ5epRYYe75REjT0izIu+pPSI+7UOXYv5c6Rm7ny8z4dPDo9zDpimpV23U0u0TIkdQZnq2mh61fPkQwMVapKz4GBbmZH1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=co/8lI/E; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7cfcb5b1e2fso3454504a34.3
        for <io-uring@vger.kernel.org>; Tue, 20 Jan 2026 07:19:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1768922382; x=1769527182; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=eqkGYhxJ9oaut4e8x0uov7pdGIztCVd4C1bTpJkfnhc=;
        b=co/8lI/EK2PQyN2Y08fmWmuJqtm9QYOhCPH+6W4H/oF1UEQzdimwyZA5tOonaa4Y9+
         LAVAA6dDS7Te7miv/xvvT96HEEH8nFW19JGSP/YTeKva8NM6ZmZv52rRiZMSPW8PE4Nu
         enYsBKhuPDXH7llUclhLiSUe48IXAgetWjanZt0HO05LczaRVCLKC+9RBUBoToNcfZSH
         PCQ0thgFb1HQkuTArG5HHsWZnfH5A1xyrnos8z+XjMjQutRy0G8pd8v0nPS5CeDZmep4
         Hb0nXpVK42WZghXkuf4m5Dl6hpippSQNlNXYBl47uZwG7O6UyZjMwDxhkv02TQPswlX8
         1yDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768922382; x=1769527182;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eqkGYhxJ9oaut4e8x0uov7pdGIztCVd4C1bTpJkfnhc=;
        b=YJ/16yuLQ4YZym4iIbFjz16qyadRyRvt9KGdh0cd1I8btc5fJ3G+CKZc/RwWWQWwOf
         DQeieomHruLA3esGgdsJJFqNkgm9efeh12QkQUjTahpscaQnLULUmpn/Z04WezIERFyo
         wSUvuoWip6J2sB8GtjOUMdiplDsObWz9vay2cNtDLQlt79l51Lr7iIrOmrJMo6Xlbow5
         xHecSpXUZJkkFtXF3wpZxmF8s/ZQMiRLxhjk0wNewlmmgiXIOlCI//qTLRpDAjs4f1hM
         foKPYvnxRnLiWX8dlcicgAlAyWPl6FO0OE5hD4FXhbOZdk/HBQpDR+mvcdt5l+aHhN+P
         c3uw==
X-Gm-Message-State: AOJu0Yzd0S5iJ3ko4K0WwWCV6VUwPtDZncdFri4L11C/jiLm3OJfwma+
	PHEs7jpSya5zwRWcTNGUYI38lzJBrywRecJlty2m0G2aWOdN2oD2dviy6iWpQ+Qsevo=
X-Gm-Gg: AY/fxX5OAYcSRFTPu/ij2czTcBzhCSUYbpVh46MRboTqYM261rR0UPF7Wm4Omy4WCOW
	956UeIjueqt0f+7mTzPsfN2ZqqJy45P1YRaZh3j/4b+DotvAJthMw06vxXb8OVvOA8bsqALpsjQ
	hFA+Hd04IhBQ4nbMv+NvXjWCx1VYh7VinqN7GM4SsuoHTqwlbeACgg9zMABF7MJARvHvQe6Jws9
	EMPeji4ZoFmgiky5FWlE2hoAji7FlThP+BWJNxoc0SuVEt4NE0w2FMwu/Xv0vsZ4e/VLKgbB0I+
	PssOhMtJ6MmPJ5eHtQ6QIKWf5PVGWxTsqyDBWdAMaFxaJbhqNiuEQq0CffKWbVh0qqKzgIKMh1n
	5v72UTwyXeagH5QOvoKmHE8aSkXweBFJDZHp8BscZtvq73VkTdudcHkcJfzJSe/BSEGr6ADpzQm
	wbKPglG1hRSIGFLi7qQXcRuYJLBVQm0b8uU5DKrWv6t2jR8xgFb78fdGHrvockYGgdiQSyi6P9E
	j8a2N8=
X-Received: by 2002:a05:6830:3747:b0:7cf:cc2c:1d7b with SMTP id 46e09a7af769-7cfdfe531b5mr8093162a34.10.1768922382106;
        Tue, 20 Jan 2026 07:19:42 -0800 (PST)
Received: from [192.168.1.102] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7cfdf0e9209sm8739387a34.8.2026.01.20.07.19.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jan 2026 07:19:41 -0800 (PST)
Message-ID: <0a9e81e3-f77a-4607-872d-aa03e9680134@kernel.dk>
Date: Tue, 20 Jan 2026 08:19:40 -0700
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [syzbot] [io-uring?] INFO: rcu detected stall in
 io_ring_exit_work (3)
To: syzbot <syzbot+33504742c13bcd6c9541@syzkaller.appspotmail.com>
Cc: io-uring@vger.kernel.org, linux-kernel@vger.kernel.org,
 syzkaller-bugs@googlegroups.com
References: <6966b578.a70a0220.245e30.0004.GAE@google.com>
Content-Language: en-US
In-Reply-To: <6966b578.a70a0220.245e30.0004.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spamd-Result: default: False [-1.46 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_DKIM_ALLOW(-0.20)[kernel-dk.20230601.gappssmtp.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	DKIM_TRACE(0.00)[kernel-dk.20230601.gappssmtp.com:+];
	DMARC_NA(0.00)[kernel.dk];
	TAGGED_FROM(0.00)[bounces-11839-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:7979, ipnet:2605:f480::/32, country:US];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dfw.mirrors.kernel.org:rdns,dfw.mirrors.kernel.org:helo,kernel.dk:mid];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[axboe@kernel.dk,io-uring@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	R_SPF_SOFTFAIL(0.00)[~all:c];
	MID_RHS_MATCH_FROM(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	TAGGED_RCPT(0.00)[io-uring,33504742c13bcd6c9541];
	SUBJECT_HAS_QUESTION(0.00)[]
X-Rspamd-Queue-Id: C889F47B12
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

Doesn't look io_uring relevant at all, and I don't know where it should go:

#syz set subsystems: kernel

-- 
Jens Axboe


