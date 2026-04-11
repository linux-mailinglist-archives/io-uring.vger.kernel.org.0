Return-Path: <io-uring+bounces-13024-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 4B8oGWw92mlCzQgAu9opvQ
	(envelope-from <io-uring+bounces-13024-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2026 14:24:12 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B9C123DFDE4
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2026 14:24:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 585D03063574
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2026 12:16:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85A402D7DDB;
	Sat, 11 Apr 2026 12:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="ajDJrE0A"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A4B7262FFC
	for <io-uring@vger.kernel.org>; Sat, 11 Apr 2026 12:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775909805; cv=none; b=EG08vQkYPmCMBXMOrNiUgPbB+Thb5OjOHzAUf6ibBV0AFbSemg/Xp4XhBSKFLCU7sjE8piUMrz7MAcv4hWV1rt10HhGk4kwF2kv1j4/AWVypjivYUYpYEdJkUl5YXolKxm+Q8JNhWmHpyXaVAtHBlr6GRb4KI9QRQ8Y0ADbjKC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775909805; c=relaxed/simple;
	bh=GB72JJsiotjmsTeSYOJVrOcPx/d3YFTtyU//wvnPopA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=IInv+nj1E5CJYIpU+az+CI64Jpgwp9iIWMJkJH0wtjuGMk10qsFBO7yys2iUTcQDD4b6Z8htsqKJsI5FqNsvwFt7tAItSyxdXVV48J2ZuX/f74j3BYqP0tI51gLIZWyvbbquS79F3XJ60OhTedSBZ5xK9QFV90HOGPqVh8RYIHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=ajDJrE0A; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-c06cb8004e8so1234856a12.0
        for <io-uring@vger.kernel.org>; Sat, 11 Apr 2026 05:16:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1775909804; x=1776514604; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=DzjRMQ0JdtxqBhtkAeDCS/1xK/Kh5wMUnQG+Jga1ziI=;
        b=ajDJrE0ASyqe3uMpVTFz6QIzc12P75ZZgBQCCdPyr5Aj8F3JbVyTql/seI6EgGW5X+
         CgYOj3uJAibI6QgSw+Sn0koDEI8ywb9dBo11rOl4bf3EqfLsQp72YbURPY0UbwTbIVaE
         c02COpsiIU9BPOxYxuUthxNxXFyPq98jG2irg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775909804; x=1776514604;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DzjRMQ0JdtxqBhtkAeDCS/1xK/Kh5wMUnQG+Jga1ziI=;
        b=VFB24Ai8YQZ87zvzh6d+/xAd7goH/HW1lVVn1xJmIEulPs17f/vbTORAvH+Qq63p4p
         /o3fMGABk7+ychX4CFwDle3njX6vKNV/iJSA7jlzl01tmUNwHdA3cIvftgQzrlt1vWKd
         MP6oSENO6ODBg0OQGpoa646xjmWEc+wDtVVOhjyI74NqRXquIy5KGRRYiWtF19BphgSF
         Mq+ikvYqwbisX+bTWoqRpk7+VjBEkZaPaA8yWSBDrUnik44Y+2+xSBGqtUnYfwwFTc0B
         OujWV/vE645LzEXP39juYpbXzwBfsQvEhOEWnUGjHhcnyXc/NRXE9dh43jmEZptnnGkd
         hn8w==
X-Forwarded-Encrypted: i=1; AJvYcCURSX4AwXWj8HJsPk2X9fm/vSxmjb9vlZMGVZEj4/par0pT0jVDwCr0ku8WGI1o65+/uA8Yen377w==@vger.kernel.org
X-Gm-Message-State: AOJu0YzSdOH8E2T2BXXXcLBuENRVGh6SpKniU/YxIdBS+//EHCTU3D/G
	1tvIwVTB5o4dnM/0+imVQT8SXWfSkNOvQxy/pjje847Bpzbufv7ZHQWZXnGpeOQCHCw=
X-Gm-Gg: AeBDietbZCBQ+zTSlXOOlAcpp7rTkcN8H7gKvCYsZSOYh4DQxb3VkHYG/TmJozY1vcI
	yuVwFuPRqYJ5MpdACYxbwYwoTQWLPmYSuS35JyAs/sijp0qFrTS/IxrcEmawoRXDJaUwJi1G3Nz
	GSqBmAfPYloMHdIdQ+dODbCdmK5TuoGRNbegxqQzOTk0KGzdytLGbg5KERM57JA8r/BUbplTDZI
	7uVedGhPCecMMFhvBeFtZgtCJ0LsUJjtYUg5b3B8LgbEYQHakGek6n5O909wUre+CZNmclNmR+a
	4MP3g99iCl+8zwZDVgF1EXIbnpms/SZ5+Gxe9TsmLdeOAy0ohrqHyF2JgMZI55Ke3D9yMlqUlng
	rvrQyFFnFjdzocUlpqu99uEX8GQsmdSdN2viU4HK/Hy8slBM1jb61Ym1xyi/q71CkcEYPdlKd4g
	GqCUKQBluPVjG8Hr8NLA==
X-Received: by 2002:a17:903:1103:b0:2b0:5a4c:726a with SMTP id d9443c01a7336-2b2d5aa7fa2mr69691975ad.43.1775909803528;
        Sat, 11 Apr 2026 05:16:43 -0700 (PDT)
Received: from sidong ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b2d4f3a8f7sm59475805ad.71.2026.04.11.05.16.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2026 05:16:43 -0700 (PDT)
Date: Sat, 11 Apr 2026 12:16:39 +0000
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/5] Rust io_uring command abstraction for miscdevice
Message-ID: <ado7p6jV6aapelBU@sidong>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
 <2026040925-taunt-exit-0cb9@gregkh>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026040925-taunt-exit-0cb9@gregkh>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[furiosa.ai,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13024-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,furiosa.ai:dkim]
X-Rspamd-Queue-Id: B9C123DFDE4
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 09, 2026 at 07:25:23AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 08, 2026 at 01:59:57PM +0000, Sidong Yang wrote:
> > This series introduces Rust abstractions for io_uring commands
> > (`IORING_OP_URING_CMD`) and wires them up to the miscdevice framework,
> > allowing Rust drivers to handle io_uring passthrough commands.
> > 
> > The series is structured as follows:
> > 
> > 1. Add io_uring C headers to Rust bindings.
> > 2. Zero-init pdu in io_uring_cmd_prep() to avoid UB from stale data.
> > 3. Core io_uring Rust abstractions (IoUringCmd, QueuedIoUringCmd,
> >    IoUringSqe, UringCmdAction type-state pattern).
> > 4. MiscDevice trait extension with uring_cmd callback.
> > 5. Sample demonstrating async uring_cmd handling via workqueue.
> > 
> > The sample completes asynchronously using a workqueue rather than
> > `io_uring_cmd_complete_in_task()`.  The latter is primarily needed
> > when completion originates from IRQ/softirq context (e.g. NVMe),
> > whereas workqueue workers already run in process context and can
> > safely call `io_uring_cmd_done()` directly.  A Rust binding for
> > `complete_in_task` can be added in a follow-up series.
> > 
> > Copy-based `read_pdu()`/`write_pdu()` are kept instead of returning
> > `&T`/`&mut T` references because the PDU is a `[u8; 32]` byte array
> > whose alignment may not satisfy `T`'s requirements.
> 
> Samples are great and all, but I would really like to see a real user of
> this before adding any more miscdev apis to the kernel.  Can you submit
> this as a series that also adds the driver that needs this at the same
> time?

Hi Greg,

Thank you for the review.

We have an out-of-tree C driver at Furiosa AI for our AI inference
accelerator that uses uring_cmd.  This is our primary motivation for
these abstractions.

We are considering upstreaming the driver and porting parts of it to
Rust using these abstractions.  If we were to upstream the driver,
would it need to be based on the accel subsystem (DRM)?  Or would a
standalone PCI driver approach also be acceptable?

Thanks,
Sidong

> 
> thanks,
> 
> greg k-h

