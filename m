Return-Path: <io-uring+bounces-13023-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kFkTEjo72mn0zAgAu9opvQ
	(envelope-from <io-uring+bounces-13023-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2026 14:14:50 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id DEB433DFC6F
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2026 14:14:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id E0BB43053AA4
	for <lists+io-uring@lfdr.de>; Sat, 11 Apr 2026 12:12:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3A04A355F52;
	Sat, 11 Apr 2026 12:12:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b="GhHhkdZp"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02EFA3537F2
	for <io-uring@vger.kernel.org>; Sat, 11 Apr 2026 12:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775909523; cv=none; b=NaZWyiVxtAKoRqEM9XbwvzFi8pCJMmqf5DPGR9LAlK3mKOn8KqFUuCOYZ1TY//rb0KyBIYGjimTTjdYCJq2FhoOfx3UtdoEdQUupBtIefJ4d7XyjABypqaS3DCisnYuJuesSoksLESuhZb5f8PH4E4Ak/P8KemPWB/soW/2QNzw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775909523; c=relaxed/simple;
	bh=zsYs4OLXoGqDPcSmx3jK/qfu7bvAUeaA/qPH6qC3Rpo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c4aROy+ez93wh0blYzpbIUUC5KHWKqXYprk30hbpEWFnKLFbfn+J6QmOYdYHy7m/Mu5fhROOa2Q2NS8NLlSh+3N8Zgt6nuNEnQUyWfO+0rjRK/saIzIhCVde3KFotV47bfbMvniTnBnyMeVZiqs4uSXhCXftaBiQwQyxLtn5VAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai; spf=none smtp.mailfrom=furiosa.ai; dkim=pass (1024-bit key) header.d=furiosa.ai header.i=@furiosa.ai header.b=GhHhkdZp; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=furiosa.ai
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=furiosa.ai
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-82f0fc82c76so579959b3a.0
        for <io-uring@vger.kernel.org>; Sat, 11 Apr 2026 05:12:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=furiosa.ai; s=google; t=1775909521; x=1776514321; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q1SyhuRgernCsatZuwdE9rDQ3zbipJuCy6jd3/mR088=;
        b=GhHhkdZpXhM74OnGkCRGDyH9B+Y/4SM9f1ixBpL9QEypLH4kq9kOADV5/gMuJfW4KV
         dGNOFJs+B9GHQpgBg1qEbnYBb/E9CkKh5ky3FqdunGWWDeVxHyfpJBD6im2HmDKms0W1
         lYr6aLRFmlqExWYOpcT3H8THNG0vBdbk0WzSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775909521; x=1776514321;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q1SyhuRgernCsatZuwdE9rDQ3zbipJuCy6jd3/mR088=;
        b=oBk9ag2QFXDX7jdo3VIf142mTBCiBiFcmgYc2o6mPMz019tzn/I7CdOeZZpqejlBzF
         QjN9/TZ5UhuP2BDGTQo+wh5LZNXPjl9kM/lGAAPLHs9iO1Zu/Xc9umtsvHp0rIkn+kvv
         HAPqooyJr+lHCzK+/GNFvUY5h4ckp9uZejsflvLBKtzgwBlJqTz5sRL1KRXGkM+i8A4E
         IDtjZdaqt9FlF1rf6ISMwswb71VEDx9/+aI/NZy9SPFxodN/qkFuk+NcQZgEUUK5YMzP
         CwImGwLRgkxehqi5v42eSlpKcJeUNGWu4N2nmimNBXxhaHWI4UJHH/IZiKvTdob38o+S
         lsMQ==
X-Forwarded-Encrypted: i=1; AJvYcCUXVzT657BTVfg9yH7h7P+t7NQs90URGGyi0yzsAsSA9DmpzyrAYWHkZQ6Bena7ZzcnBq0meXF9Gw==@vger.kernel.org
X-Gm-Message-State: AOJu0YytG4aNq7PFWbxNMgKaYcmVKkMBNdyxOmZpFPTJrqdAf3BfZR1A
	dgYF5UNTMrFFBLxETa29ZxurOgp1IAbwAyP4rrZ6Eu3g4DQYiMfl1VlyV8xlTeWcxa0=
X-Gm-Gg: AeBDietIkL1Hi9gAHGtHnyFAl8nGj/cm8vc3VfDH06uOQXj3aXaX5yH5nCLI7cRg76D
	zzrxOJfvOJjmxAH5u+EkBiCaxPE6oRONy9OfnqCr+DTp/+1iOjjSzhFouSGSlJlZtXEY5+i8ier
	lska1QfF8HVQWW6q45tIgetA0W/afEpVOn8vVj4FmK/upIbOgdSA3F1ohunTFkipnVoX3z4p+tC
	siaLvopWhp5z1NI3d24uRdOZgEKft4cpuZOxsHXqZCURi0ihO0Mm/j0shTTxwToktXHPEzBG28A
	PvB0ufuvANUFKW7DBywWA0RaQb6dJEbrehxVNxJ+pYu1MMotgVLiv7ndUBGUCWFe/+Aib+PPGo5
	jaQ/TtOXCiBMh+pGvj9FDjPV1jPpW0HtjDFh4dnkaODr0N4clpnWT/MshL5bfFC4n9GPEm05lDn
	7JY+b5zEsywkB624b10w==
X-Received: by 2002:a05:6a00:138c:b0:82c:21af:a7bf with SMTP id d2e1a72fcca58-82f0c15db51mr7233864b3a.13.1775909521285;
        Sat, 11 Apr 2026 05:12:01 -0700 (PDT)
Received: from sidong ([61.83.209.48])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82f0c4b6d43sm4993403b3a.31.2026.04.11.05.11.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 11 Apr 2026 05:12:00 -0700 (PDT)
Date: Sat, 11 Apr 2026 12:11:56 +0000
From: Sidong Yang <sidong.yang@furiosa.ai>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jens Axboe <axboe@kernel.dk>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Caleb Sander Mateos <csander@purestorage.com>,
	Benno Lossin <lossin@kernel.org>, Miguel Ojeda <ojeda@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>, rust-for-linux@vger.kernel.org,
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH v4 2/5] io_uring/cmd: zero-init pdu in
 io_uring_cmd_prep() to avoid UB
Message-ID: <ado6jBVkfs8JNmO-@sidong>
References: <20260408140007.8401-1-sidong.yang@furiosa.ai>
 <20260408140007.8401-3-sidong.yang@furiosa.ai>
 <2026040908-certainly-dealmaker-5530@gregkh>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026040908-certainly-dealmaker-5530@gregkh>
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[furiosa.ai,none];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[furiosa.ai:s=google];
	R_SPF_ALLOW(-0.20)[+ip4:172.232.135.74:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[furiosa.ai:+];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13023-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,furiosa.ai:dkim]
X-Rspamd-Queue-Id: DEB433DFC6F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Thu, Apr 09, 2026 at 07:27:18AM +0200, Greg Kroah-Hartman wrote:
> On Wed, Apr 08, 2026 at 01:59:59PM +0000, Sidong Yang wrote:
> > The pdu field in io_uring_cmd may contain stale data when a request
> > object is recycled from the slab cache. Accessing uninitialized or
> > garbage memory can lead to undefined behavior in users of the pdu.
> 
> Who accesses this?  If that happens, then yes this is a problem, but if
> not, then there's no need for this change, right (i.e. either this is a
> bug to be fixed now or not.)

Hi Greg,

Thank you for the review.

You are right, this patch is not fixing an existing bug.  I added it
because the Rust abstraction provides read_pdu() which reads from the
PDU, and without zero-initialization a Rust caller could observe stale
data from a recycled slab object.  While "stale but valid" might be
harmless in C, in Rust we want to guarantee a clean initial state.

That said, I realize this is a C-side change that is only motivated by
the Rust side.  I will drop this patch from the series and handle
zero-initialization within the Rust miscdevice vtable wrapper instead
(which the current code already does).

Thanks,
Sidong

> 
> > Ensure the pdu buffer is cleared during io_uring_cmd_prep() so that
> > each command starts from a well-defined state. This avoids exposing
> > uninitialized memory and prevents potential misinterpretation of data
> > from previous requests.
> 
> Where is the memory exposed and who misinterprets it?
> 
> > No functional change is intended other than guaranteeing that pdu is
> > always zero-initialized before use.
> 
> This strongly implies that this is not needed at all.
> 
> thanks,
> 
> greg k-h

