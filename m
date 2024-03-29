Return-Path: <io-uring+bounces-1337-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id E430A892695
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 23:04:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 839BA1F21E1D
	for <lists+io-uring@lfdr.de>; Fri, 29 Mar 2024 22:04:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B3E9013CAA1;
	Fri, 29 Mar 2024 22:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="vhOLWXIp";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="NNwdDyhu"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2602C13C9D4
	for <io-uring@vger.kernel.org>; Fri, 29 Mar 2024 22:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711749878; cv=none; b=snWicLtXMFirM5TAzG/DvEG5uCiudV5IU4UdT3soKOUQEA/5nixLTP4uCb7k9kvAsc9l+N2Bd22UFpShef7dhRKEOvx+1RfmQshbIlsQpSduepg8pOXl3GSQf39wNyORPi4lTW4qw8pEjxvYeVQcfSQ+CUZ5avNihT6wnI3Olq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711749878; c=relaxed/simple;
	bh=mrTCUFk4a679OrUVXp/6Dsx3ZMeW4fhMWDjNWziXzuE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=rXZdLqYZUxVPd/50nVT2Lq38z4GRZ8sXyg1gf7UPTtRk3npcBbho1UX2gwb7ydS0+980MnACaulVM/TmPJ3bNMWDcJsLuw3RvsV34pMEwG7HPFMVDfLpsTEV4Fdrezu4JnY4xWLVse0sGKtg62C+ef3h0H02UB1l0Jku16jmJqU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=vhOLWXIp; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=NNwdDyhu; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [10.150.64.98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 6307935375;
	Fri, 29 Mar 2024 22:04:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1711749875; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KHjZM/nYyQ/w6nvsrEZmOibX9zXaPlyi2JXzlsGSuKg=;
	b=vhOLWXIp/QB1yO7f3u4wHdf9ZQ6GdsYMq+ocHRs//8AJbxnDnWwivY/EsP3VRTHuD3CANs
	g/K7yI17OTTWxrxgU7rTqtPNuDYcp+szlH1dW+KZuzDbuIH4hgT2DS25EMrb9ECg6oTOQM
	ylGeBwKvcdDiCgIQz9tYiPiChfXBoDM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1711749875;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KHjZM/nYyQ/w6nvsrEZmOibX9zXaPlyi2JXzlsGSuKg=;
	b=NNwdDyhuLZ95P8Iju17tn1llrpgR+2hGLGHUqDxCLzE18+xG/5KCHDS4MjXS70Ox+30Vxl
	jdmgzbeCX5zvBqAQ==
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 13EDE13A89;
	Fri, 29 Mar 2024 22:04:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id vdk8NPI6B2ZwVAAAn2gu4w
	(envelope-from <krisman@suse.de>); Fri, 29 Mar 2024 22:04:34 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: kernel test robot <lkp@intel.com>
Cc: oe-kbuild-all@lists.linux.dev,  llvm@lists.linux.dev,
 io-uring@vger.kernel.org
Subject: Re: [axboe-block:for-6.10/io_uring 42/42]
 io_uring/register.c:175:24: warning: arithmetic between different
 enumeration types ('enum io_uring_register_restriction_op' and 'enum
 io_uring_register_op')
In-Reply-To: <202403291458.6AjzdI64-lkp@intel.com> (kernel test robot's
	message of "Fri, 29 Mar 2024 14:23:33 +0800")
References: <202403291458.6AjzdI64-lkp@intel.com>
Date: Fri, 29 Mar 2024 18:04:29 -0400
Message-ID: <87h6go66fm.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -1.61
X-Spamd-Result: default: False [-1.61 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 RCPT_COUNT_THREE(0.00)[4];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-0.999];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.31)[75.43%]
X-Spam-Level: 
X-Spam-Flag: NO

kernel test robot <lkp@intel.com> writes:

[+ io_uring list ]

>>> io_uring/register.c:175:24: warning: arithmetic between different
> enumeration types ('enum io_uring_register_restriction_op' and 'enum
> io_uring_register_op') [-Wenum-enum-conversion]
>      175 |         if (!arg || nr_args > IORING_MAX_RESTRICTIONS)
>          |                               ^~~~~~~~~~~~~~~~~~~~~~~
>    io_uring/register.c:31:58: note: expanded from macro 'IORING_MAX_RESTRICTIONS'
>       31 | #define IORING_MAX_RESTRICTIONS (IORING_RESTRICTION_LAST + \
>          |                                  ~~~~~~~~~~~~~~~~~~~~~~~ ^
>       32 |                                  IORING_REGISTER_LAST + IORING_OP_LAST)
>          |                                  ~~~~~~~~~~~~~~~~~~~~
>    14 warnings generated.

hm.

Do we want to fix?  The arithmetic is safe here.  I actually tried
triggering the warning with gcc, but even with -Wenum-conversion in
gcc-12 (which is in -Wextra and we don't use in the kernel build), I
couldn't do it.  only llvm catches this.

can we explicit cast to int to silent it?

-- 
Gabriel Krisman Bertazi

