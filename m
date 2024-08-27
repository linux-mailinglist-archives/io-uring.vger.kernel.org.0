Return-Path: <io-uring+bounces-2954-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 303D195FE29
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 03:13:11 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5B1B51C21A3A
	for <lists+io-uring@lfdr.de>; Tue, 27 Aug 2024 01:13:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4CEEA33E8;
	Tue, 27 Aug 2024 01:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QyqHs4yl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+5WT+e4+";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="QyqHs4yl";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="+5WT+e4+"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F23F1C2E;
	Tue, 27 Aug 2024 01:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724721187; cv=none; b=QqvXPFPUzARCliEU3MbELXiBHyFe5spZJrjhE2ogVfzGuWb2YB48tbw5p1oncC1uVaOY4RA50FV8AodGieLoKEL1l5V0iIF4ym2mSbOgzgMtq1SaA+aEk/R0KuNA9YU5FgChqQC8eWlfgmPRtBHqCwnCjhVd+d0fv0JDje6QhGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724721187; c=relaxed/simple;
	bh=aNoL+ykWfWNQAvvZuiDPIYkBFzKPFhLSiKYzADFs9HI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jX98jXBsOZsfyLSRGi8hv4TtH67J8xcNrcO72Un/dx1XRpd5G8mISWEoENe3O4DuADxbO4Hm75KZANKLN5ruZFLAZlDRNnjbvMgqMSENhHQXxS0ttXQD0xH887sYOWQjERnzAkkDF3vxr01dn83Gyx09C1zX0EHgxAkuHdAL50w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QyqHs4yl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+5WT+e4+; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=QyqHs4yl; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=+5WT+e4+; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7EA3C219E8;
	Tue, 27 Aug 2024 01:13:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724721183;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aNoL+ykWfWNQAvvZuiDPIYkBFzKPFhLSiKYzADFs9HI=;
	b=QyqHs4yl30v6yv949vBAGG4w2EkLTlMgHBJESwz46+I8j2emvAVszAnqg/Io7i1HbwH+wI
	KjiZ7WODAd7v6sZEoW7V7gE/A/N3eSQWLl93D7KLzaiOSqyEsmXAvUN5QBhg3D9O15s2rX
	RnNye+N7HuqcYNAqelFbKE21UI8FyHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724721183;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aNoL+ykWfWNQAvvZuiDPIYkBFzKPFhLSiKYzADFs9HI=;
	b=+5WT+e4+djFaEjRfRcKjkRi/Rt4MPDeNS73b4lNjtvu0TVrpqP3uzYxyou8mBIJMbZ6JOC
	OZGQmk5ZTQX8ZtCQ==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1724721183;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aNoL+ykWfWNQAvvZuiDPIYkBFzKPFhLSiKYzADFs9HI=;
	b=QyqHs4yl30v6yv949vBAGG4w2EkLTlMgHBJESwz46+I8j2emvAVszAnqg/Io7i1HbwH+wI
	KjiZ7WODAd7v6sZEoW7V7gE/A/N3eSQWLl93D7KLzaiOSqyEsmXAvUN5QBhg3D9O15s2rX
	RnNye+N7HuqcYNAqelFbKE21UI8FyHU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1724721183;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aNoL+ykWfWNQAvvZuiDPIYkBFzKPFhLSiKYzADFs9HI=;
	b=+5WT+e4+djFaEjRfRcKjkRi/Rt4MPDeNS73b4lNjtvu0TVrpqP3uzYxyou8mBIJMbZ6JOC
	OZGQmk5ZTQX8ZtCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6B90D13724;
	Tue, 27 Aug 2024 01:13:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id AH/GGR8ozWYVFgAAD6G6ig
	(envelope-from <dsterba@suse.cz>); Tue, 27 Aug 2024 01:13:03 +0000
Date: Tue, 27 Aug 2024 03:12:58 +0200
From: David Sterba <dsterba@suse.cz>
To: Mark Harmstone <maharmstone@fb.com>
Cc: io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 1/6] btrfs: remove iocb from btrfs_encoded_read
Message-ID: <20240827011258.GX25962@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20240823162810.1668399-1-maharmstone@fb.com>
 <20240823162810.1668399-2-maharmstone@fb.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240823162810.1668399-2-maharmstone@fb.com>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Score: -4.00
X-Spamd-Result: default: False [-4.00 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	HAS_REPLYTO(0.30)[dsterba@suse.cz];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_TLS_ALL(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	REPLYTO_ADDR_EQ_FROM(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,twin.jikos.cz:mid];
	RCVD_COUNT_TWO(0.00)[2];
	REPLYTO_DOM_NEQ_TO_DOM(0.00)[]
X-Spam-Flag: NO
X-Spam-Level: 

On Fri, Aug 23, 2024 at 05:27:43PM +0100, Mark Harmstone wrote:
> We initialize a struct kiocb for encoded reads, but this never gets
> passed outside the driver. Simplify things by replacing it with a file,
> offset pair.

Please change the subject so it matches the description, so
"btrfs: replace iocb with file and offset in btrfs_encoded_read()"

