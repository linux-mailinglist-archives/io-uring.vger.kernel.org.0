Return-Path: <io-uring+bounces-3695-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id B32B199F103
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 17:24:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 656071F22D4C
	for <lists+io-uring@lfdr.de>; Tue, 15 Oct 2024 15:24:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 72D341B3936;
	Tue, 15 Oct 2024 15:23:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MG11RX51";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kulijqIk";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="MG11RX51";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="kulijqIk"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E731D5160;
	Tue, 15 Oct 2024 15:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729005829; cv=none; b=Q6G7yQipM1a4AQsS7Ist1NTKehIvsZPvf/LQvnR6/ThDx8VdtVTcR7JW3PFbQRTbpIBPgWBy3JL0dsMUWaVTcSvnRyVmyqbRX/TVWBMVh92AkKx16WFQlneewrtJA2iS98sit8VDXVMUlNPWNgHzRx+iPzzKxAl98lw7e9Y2RXE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729005829; c=relaxed/simple;
	bh=drQwcUIQ3ixZ1YOel/6e3vXC1miu1xlUEh3lxCn5j7E=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UwxPeEKituF2WtM1mnGA06mPoMpSg/WQwb3HL5TurIgCXTKKQYjx/xP4+Fw3eXPSNGVwesDA/ntibF5UsVEBF2O6UDnaahK1M93R9pvgE21OYauKFLU2KqPR74eEU2zWmXCEC/n0SW4/xPDSoEgiXXLv1PS7RHXoUnnq2BrUfEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MG11RX51; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kulijqIk; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=MG11RX51; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=kulijqIk; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D3A851F7D1;
	Tue, 15 Oct 2024 15:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1729005825;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=drQwcUIQ3ixZ1YOel/6e3vXC1miu1xlUEh3lxCn5j7E=;
	b=MG11RX51UqvJW6BEMLfX5+aSx+80DR8GDhuNaTz/quQRTye+Gr58Hoxo+li526CWIAyi8g
	ebaCocgjKmlgT5ixGo3Un9Bm/1BvRE9kXqK1uOPFsSAoF99XusDfhbcSp6yrM/plT2hZxd
	taI8WVe2GLsww7GOgqN1n5/mI5JRfBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1729005825;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=drQwcUIQ3ixZ1YOel/6e3vXC1miu1xlUEh3lxCn5j7E=;
	b=kulijqIk7sxHaphFBFAoVxZUke7iuIrHRK4m1zK9cfkiNss1Y4lkMHJsF9KV/2Nirtv7Uw
	k3DV4+6Bi7oOdPDg==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1729005825;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=drQwcUIQ3ixZ1YOel/6e3vXC1miu1xlUEh3lxCn5j7E=;
	b=MG11RX51UqvJW6BEMLfX5+aSx+80DR8GDhuNaTz/quQRTye+Gr58Hoxo+li526CWIAyi8g
	ebaCocgjKmlgT5ixGo3Un9Bm/1BvRE9kXqK1uOPFsSAoF99XusDfhbcSp6yrM/plT2hZxd
	taI8WVe2GLsww7GOgqN1n5/mI5JRfBI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1729005825;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=drQwcUIQ3ixZ1YOel/6e3vXC1miu1xlUEh3lxCn5j7E=;
	b=kulijqIk7sxHaphFBFAoVxZUke7iuIrHRK4m1zK9cfkiNss1Y4lkMHJsF9KV/2Nirtv7Uw
	k3DV4+6Bi7oOdPDg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B956913A42;
	Tue, 15 Oct 2024 15:23:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id m4kALQGJDmcsFwAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 15 Oct 2024 15:23:45 +0000
Date: Tue, 15 Oct 2024 17:23:40 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: linux-btrfs@vger.kernel.org, io-uring@vger.kernel.org
Subject: Re: [PATCH 2/5] btrfs: change btrfs_encoded_read_regular_fill_pages
 to take a callback
Message-ID: <20241015152340.GH1609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20241014171838.304953-1-maharmstone@fb.com>
 <20241014171838.304953-3-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241014171838.304953-3-maharmstone@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_ALL(0.00)[];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FROM_EQ_ENVFROM(0.00)[];
	TO_DN_SOME(0.00)[];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_HAS_DN(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

On Mon, Oct 14, 2024 at 06:18:24PM +0100, Mark Harmstone wrote:
> Change btrfs_encoded_read_regular_fill_pages so that it takes a callback
> rather than waiting, and add new helper function btrfs_encoded_read_wait_cb
> to match the existing behaviour.

Please avoid callbacks and function pointers when it's in the same
subsystem. Pass some enum and do a switch inside the function, or wrap
it to a helper if needed. Since spectre/meltdown function pointers in
kernel have been removed when possible and I don't see a strong reason
for it here.

