Return-Path: <io-uring+bounces-13039-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2ME8Afte3mn+CQAAu9opvQ
	(envelope-from <io-uring+bounces-13039-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 17:36:27 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 9D07B3FBF55
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 17:36:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id B954130078AC
	for <lists+io-uring@lfdr.de>; Tue, 14 Apr 2026 15:36:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ABB163EBF33;
	Tue, 14 Apr 2026 15:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="KD5cfuVN"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789B53EAC90
	for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 15:36:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776180982; cv=none; b=iukI3EW3J5bXd3DOO9poNPlS2UUxiDnRTPeO3C5ixnkCmjM4KGeLVDXEJ0GxFTc3wXBhIjw+k+BKNT06kOE7LcidgstGzljmNOvont22z9cr76XZgC4HpvQ8qvnl7gZ7S/JjEy/t0/Lm29j6XOktcG2jfSlsk6xHFlmLcom2u0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776180982; c=relaxed/simple;
	bh=P7azTpi+MN/jyrZ5BBlCVFneGWvJ6Ty3e+joKzhgGGM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XQuqHeAbudTm3KhwiVUDDGqiRLmJgzPgObw15L+6bst0c4g2rF621wLdIO5UfUJD7r/QEpCmmk1eCsCXu4aSYllicI41Mlp4kQ5+7iYS/s629+4d2PMYpevLD+TM/8VZuZfTPHevTuEtQk7bBO5VJlDdo0YgzafkPuRTQHOEH0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=KD5cfuVN; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2b25cf1b5f0so38265855ad.3
        for <io-uring@vger.kernel.org>; Tue, 14 Apr 2026 08:36:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1776180981; x=1776785781; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FPzXW8AqKhqoLGflDV8nOPkwdCJG/GLfLI3Z+E/2MF0=;
        b=KD5cfuVNkVGv5g8XafkH5Iht1dtvjoCbx7yC4I86qT8tYfM/jzpPIytR872GIkJMya
         VZ72uBIdd4oxTAEC9GYJyBk2MWvmpOTLktY7sNmG1t0snJZIt50eVZ9K7s9NDSPehMze
         K35t3da6t4FTdFkQlfn+d3Sb0FM1LMlFuLafU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776180981; x=1776785781;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FPzXW8AqKhqoLGflDV8nOPkwdCJG/GLfLI3Z+E/2MF0=;
        b=oUMS9DlV40xcAvQNKgV5Eal7a+40QAn86YlmHzLpvmSvL/mDpiXxf6SzHLa6FuKhkK
         IaJ3YrVYhBILY2FSTVAHUfL14zUy6RRmbqPvsHfN8ujZZUhR9nD7JfUxj9/v+BWgLzs2
         HXtgYvg4ST3KfW5jUH7Tuy0mL0UGeFJtaavpxXEfFk3NwvDHSn2mbuqLQneGcGeKEVwk
         MMRrBWcZX7D7LRWMqu12eTXtZtYgCSQAN4bs0F5dbeHsweVvXpxTXVPXGZPRtMD6O1pU
         zL6hEtkCy1kBZNIk7E3fZovYLBPnslfXkHytEBckDoNfomaHczUNd4Ltat3qqHaZuN3t
         F/Ag==
X-Forwarded-Encrypted: i=1; AFNElJ/Jpy+dh13a1Bk315P/LEfppJEhjuYCRH+rE/Ok2lHYQ1Ou1LuQJpBSRk2EkF+Q9G6PQS/MoDncqg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzf5q0jwOWHLT78SctDSooGNTfQE1ckDVvSnBSQCMrtsiOdU83Q
	1nYdfPEnA94RzBBBAuxCgBEveqp7u699BNs6d5Em09sB6nnuncNLpididLVmFIPFwBY=
X-Gm-Gg: AeBDiescKJsPwZF5MwvJvb5IuNYUSqfT6u3FyeR9klX3cRzJkAdMI+YTbtbJ7Ik7tde
	mRXB3psnrUvZIkzu7wCQgEm6UyG6JrSTFF8eEDdpX7esA0B3JBZFt33818uAZtHBplNFq7Q+iug
	FXecXTsoUH0n9ASw/F5lI6dqUQ8zLjYDSHX1nLWcxcU4jHlBTeVLHPAag/wXRMjN+lOBQArVJH8
	FztkfJvuZTJxsKV+TycTb/A2HZi2nH7sqScruf0fVlo4eNBf4VX51bQ3cXaqiXYXtXNsEbFjSW2
	Y56bC3+O4Q2WQzrIrxNW2NOHrg9goUhO1wNj5NsNSKO7kG9WTnofPkeIl3l2dKg41JTm/tM66Co
	CGsdpjOXuNrZVyADwUgvpymEcn/nH3go6TsTMCIthSBgNTZvkw69aRNQ0ZcABmBjlyt4i+yY3ec
	rHVU6yAvq3jOkDNAQWHhI+NKq++P3DzeWS5eD2rE4Jp+085gIHmIoWQahKRKk=
X-Received: by 2002:a17:902:cf11:b0:2b0:beb4:3bb with SMTP id d9443c01a7336-2b2d593bd65mr186882965ad.10.1776180980645;
        Tue, 14 Apr 2026 08:36:20 -0700 (PDT)
Received: from sidongui-MacBookPro.local ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b45e949464sm89557465ad.24.2026.04.14.08.36.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Apr 2026 08:36:20 -0700 (PDT)
Date: Wed, 15 Apr 2026 00:36:05 +0900
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 0/5] Rust io_uring command abstraction for miscdevice
Message-ID: <ad5e5cAmtL8GRo-s@sidongui-MacBookPro.local>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
 <2026040925-taunt-exit-0cb9@gregkh>
 <ado7p6jV6aapelBU@sidong>
 <2026041153-scope-five-fd24@gregkh>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026041153-scope-five-fd24@gregkh>
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[furiosa.ai,none];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13039-lists,io-uring=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MISSING_XM_UA(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sidong.yang@furiosa.ai,io-uring@vger.kernel.org];
	ASN(0.00)[asn:63949, ipnet:172.232.128.0/19, country:SG];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,furiosa.ai:dkim,sidongui-MacBookPro.local:mid]
X-Rspamd-Queue-Id: 9D07B3FBF55
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Sat, Apr 11, 2026 at 02:27:14PM +0200, Greg Kroah-Hartman wrote:
> On Sat, Apr 11, 2026 at 12:16:39PM +0000, Sidong Yang wrote:
> > On Thu, Apr 09, 2026 at 07:25:23AM +0200, Greg Kroah-Hartman wrote:
> > > On Wed, Apr 08, 2026 at 01:59:57PM +0000, Sidong Yang wrote:
> > > > This series introduces Rust abstractions for io_uring commands
> > > > (`IORING_OP_URING_CMD`) and wires them up to the miscdevice framework,
> > > > allowing Rust drivers to handle io_uring passthrough commands.
> > > > 
> > > > The series is structured as follows:
> > > > 
> > > > 1. Add io_uring C headers to Rust bindings.
> > > > 2. Zero-init pdu in io_uring_cmd_prep() to avoid UB from stale data.
> > > > 3. Core io_uring Rust abstractions (IoUringCmd, QueuedIoUringCmd,
> > > >    IoUringSqe, UringCmdAction type-state pattern).
> > > > 4. MiscDevice trait extension with uring_cmd callback.
> > > > 5. Sample demonstrating async uring_cmd handling via workqueue.
> > > > 
> > > > The sample completes asynchronously using a workqueue rather than
> > > > `io_uring_cmd_complete_in_task()`.  The latter is primarily needed
> > > > when completion originates from IRQ/softirq context (e.g. NVMe),
> > > > whereas workqueue workers already run in process context and can
> > > > safely call `io_uring_cmd_done()` directly.  A Rust binding for
> > > > `complete_in_task` can be added in a follow-up series.
> > > > 
> > > > Copy-based `read_pdu()`/`write_pdu()` are kept instead of returning
> > > > `&T`/`&mut T` references because the PDU is a `[u8; 32]` byte array
> > > > whose alignment may not satisfy `T`'s requirements.
> > > 
> > > Samples are great and all, but I would really like to see a real user of
> > > this before adding any more miscdev apis to the kernel.  Can you submit
> > > this as a series that also adds the driver that needs this at the same
> > > time?
> > 
> > Hi Greg,
> > 
> > Thank you for the review.
> > 
> > We have an out-of-tree C driver at Furiosa AI for our AI inference
> > accelerator that uses uring_cmd.  This is our primary motivation for
> > these abstractions.
> > 
> > We are considering upstreaming the driver and porting parts of it to
> > Rust using these abstractions.  If we were to upstream the driver,
> > would it need to be based on the accel subsystem (DRM)?  Or would a
> > standalone PCI driver approach also be acceptable?
> 
> Yes, it must use the accel subsystem as that is the correct api for it.

Thanks for the clarification.

I will proceed with this uring_cmd Rust abstraction patch as is. Moving 
forward with our AI accelerator driver, I will look into implementing it 
using the accel subsystem and work on creating the necessary Rust 
abstractions for it.

Since I am planning to adopt the accel subsystem, could you share some 
insights on the main benefits it provides for AI accelerators, or point me 
to any future roadmap/plans for the subsystem? This would be very helpful 
for my design and implementation.

Thanks,
Sidong

> 
> thanks,
> 
> greg k-h

