Return-Path: <io-uring+bounces-11994-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id SEtZDpfSfGlbOwIAu9opvQ
	(envelope-from <io-uring+bounces-11994-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 16:47:35 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B048CBC310
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 16:47:34 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D4D4430166DB
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 15:47:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E7C4328B69;
	Fri, 30 Jan 2026 15:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cw3UOH+/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JqFgkRcF";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Cw3UOH+/";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="JqFgkRcF"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A0C633A9D3
	for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 15:47:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769788044; cv=none; b=FLVx2SQOZHTWr5Nom4Xy5/RTxKd9K2mzcEjmSrYWgiqS49DZBFj4o8tSyNWwucr1A141MxJvQ6sPMX+cKOvfhCBppXGODTIx+XGVOUOH6QRwFosHVbvS5r6ygMzHPwIiHE4PFO3p9tpvMuvS9yjz5KxhR4CKdsrybLhyHhJSHcU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769788044; c=relaxed/simple;
	bh=BT0q+6gZIPGG8IyhY2pRrZ0/t/cj+TlofEPyFeaQXRU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=juMvv1G4BCjIn9m8lVFK0FXOOdmyTy57J8eRX548Pdcu16c/J1m9euZS9QrlQP41Si2TCY6McKC+x2QkcA/kEnnhR3vHlEGpzMTmKMZNSupxuU6ghradDep2IN0YxX285D7zkKoU1f8eCtdLIyqQDogBZC2FSdAbaZuh/fQOEH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cw3UOH+/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JqFgkRcF; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Cw3UOH+/; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=JqFgkRcF; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 67FD15BD64;
	Fri, 30 Jan 2026 15:47:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769788039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pK0lObbqbQw2n0nbFh4iKLS82/TwVrSfO51QZsG0HBc=;
	b=Cw3UOH+/2ms7XaX+KU2dyn8olZ5Hrjg+sA91wgglanSC2nFz/sQYEIiR+/AqFD6h/igNrL
	wAUBe4VYdX2OMMIYxs0h14+xRhntyfX9Ean6tL9oYxTebrD5fgd28MkAJTWU9NQHrwaQ37
	N+pynTkF5m7A+DBrV7Vv2fLftMK862s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769788039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pK0lObbqbQw2n0nbFh4iKLS82/TwVrSfO51QZsG0HBc=;
	b=JqFgkRcFNWULZfVAJNUvh7UbsUYkDLfHad2EKGcoDxLJb/5Za5n6jbUe6Aq8P+rfc4aZNO
	icitgW7EMonznaDA==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1769788039; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pK0lObbqbQw2n0nbFh4iKLS82/TwVrSfO51QZsG0HBc=;
	b=Cw3UOH+/2ms7XaX+KU2dyn8olZ5Hrjg+sA91wgglanSC2nFz/sQYEIiR+/AqFD6h/igNrL
	wAUBe4VYdX2OMMIYxs0h14+xRhntyfX9Ean6tL9oYxTebrD5fgd28MkAJTWU9NQHrwaQ37
	N+pynTkF5m7A+DBrV7Vv2fLftMK862s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1769788039;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=pK0lObbqbQw2n0nbFh4iKLS82/TwVrSfO51QZsG0HBc=;
	b=JqFgkRcFNWULZfVAJNUvh7UbsUYkDLfHad2EKGcoDxLJb/5Za5n6jbUe6Aq8P+rfc4aZNO
	icitgW7EMonznaDA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2156D3EA63;
	Fri, 30 Jan 2026 15:47:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id pkRFOobSfGlmHwAAD6G6ig
	(envelope-from <krisman@suse.de>); Fri, 30 Jan 2026 15:47:18 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: kernel test robot <lkp@intel.com>
Cc: axboe@kernel.dk,  oe-kbuild-all@lists.linux.dev,
  io-uring@vger.kernel.org,  Andrew Morton <akpm@linux-foundation.org>,
  Linux Memory Management List <linux-mm@kvack.org>,  David Hildenbrand
 <david@kernel.org>,  Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
  Vlastimil Babka <vbabka@suse.cz>,  "Liam R. Howlett"
 <Liam.Howlett@oracle.com>,  Mike Rapoport <rppt@kernel.org>,  Suren
 Baghdasaryan <surenb@google.com>,  Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
In-Reply-To: <202601301341.PTetVieu-lkp@intel.com> (kernel test robot's
	message of "Fri, 30 Jan 2026 14:03:20 +0800")
References: <20260129221138.897715-3-krisman@suse.de>
	<202601301341.PTetVieu-lkp@intel.com>
Date: Fri, 30 Jan 2026 10:47:17 -0500
Message-ID: <87jywz9k6y.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Flag: NO
X-Spam-Score: -4.30
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11994-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[git-scm.com:url,01.org:url,intel.com:email,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.de:dkim,mailhost.krisman.be:mid]
X-Rspamd-Queue-Id: B048CBC310
X-Rspamd-Action: no action

kernel test robot <lkp@intel.com> writes:

> Hi Gabriel,
>
> kernel test robot noticed the following build warnings:
>
> [auto build test WARNING on v6.19-rc7]
> [also build test WARNING on linus/master]
> [cannot apply to axboe/for-next next-20260129]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Gabriel-Krisman-Bertazi/io_uring-Support-commands-with-optional-file-descriptors/20260130-061445
> base:   v6.19-rc7
> patch link:    https://lore.kernel.org/r/20260129221138.897715-3-krisman%40suse.de
> patch subject: [PATCH 2/2] io_uring: introduce IORING_OP_MMAP
> config: m68k-randconfig-r122-20260130 (https://download.01.org/0day-ci/archive/20260130/202601301341.PTetVieu-lkp@intel.com/config)
> compiler: m68k-linux-gcc (GCC) 8.5.0
> reproduce (this is a W=1 build): (https://download.01.org/0day-ci/archive/20260130/202601301341.PTetVieu-lkp@intel.com/reproduce)
>
> If you fix the issue in a separate patch/commit (i.e. not just a new version of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Closes: https://lore.kernel.org/oe-kbuild-all/202601301341.PTetVieu-lkp@intel.com/
>
> sparse warnings: (new ones prefixed by >>)
>>> io_uring/mmap.c:116:36: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
>    io_uring/mmap.c:116:36: sparse:     expected void [noderef] __user *addr
>    io_uring/mmap.c:116:36: sparse:     got void *
>    io_uring/mmap.c:125:44: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
>    io_uring/mmap.c:125:44: sparse:     expected void [noderef] __user *addr
>    io_uring/mmap.c:125:44: sparse:     got void *
>    io_uring/mmap.c:130:28: sparse: sparse: incorrect type in assignment (different address spaces) @@     expected void [noderef] __user *addr @@     got void * @@
>    io_uring/mmap.c:130:28: sparse:     expected void [noderef] __user *addr
>    io_uring/mmap.c:130:28: sparse:     got void *

FWIW, for reviewers, these are false positives.  The issue is I'm using
"void* __user addr" to either return a pointer or the error code to
user.  It is properly copied back through copy_to_user, but sparse still
complains.  I'll look into silencing it.

-- 
Gabriel Krisman Bertazi

