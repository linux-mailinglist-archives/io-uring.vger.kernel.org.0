Return-Path: <io-uring+bounces-3270-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 344EC97F12D
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 21:20:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 65C481C20FAE
	for <lists+io-uring@lfdr.de>; Mon, 23 Sep 2024 19:20:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B38C3BB25;
	Mon, 23 Sep 2024 19:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="qrACTAfo";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="DZty9dGR";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="iTA4Qvwy";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="2+6PpG5E"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6E2A15E86
	for <io-uring@vger.kernel.org>; Mon, 23 Sep 2024 19:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727119239; cv=none; b=cJmSX7j7L7uKT1+9XrveoC1uxW6AANlqbawTn6T3nuCEARd/uN33yMgA7te1JahyAjKydbAKFrnEgrud70wlJ27v/B2sUx1ryUZXHYbPakQIn8X/Ra6F85dwZCk1A26b1LXH4jvnlOf2JNM6d7SrF4F8U+RK723qmaukhZlDeQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727119239; c=relaxed/simple;
	bh=F460sGDuilL4k6KAIeq8MVFlEdajVUgGeWszPNyD7Wo=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=dlcXa/PltC+VrdH1CMvSz90QFJSsHeJpCfYK7wyDPIg8j/udCPf1nZlHHrBLng6FhGO+7GrFmNdsR4lcZ2NGtM7xlYe3HF2HF5qjOHuvcmT2GI9fWSImjTabomiekKUpSfG6Sz/Hlgmljbr5XCke4MROiJQRIAykJl9EeWQMswg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=qrACTAfo; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=DZty9dGR; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=iTA4Qvwy; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=2+6PpG5E; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D29761F390;
	Mon, 23 Sep 2024 19:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727119233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kl2d+CZB6CgaqLrv2yHE0GbyB4cwMtXMquA2i+yIlaQ=;
	b=qrACTAfoe1Umd1BerHy7VCbX7GZwO4P+fdAbuZQK5d3dHt3g9UNyoX+V3QzGHBqVNpMP3s
	Ai7GWuhEQhKm9QqUvv9l/eL//cQbR3II8suLmkRGE+6y2igGBEVsSAtNQjEZcyUyK/ReqO
	934p1XikiV3MFcpeFjOhi0EChV1cSJ8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727119233;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kl2d+CZB6CgaqLrv2yHE0GbyB4cwMtXMquA2i+yIlaQ=;
	b=DZty9dGR75+yicD+DgEx6UBV+2SZKq1CVgZS+kNM+kOYw/GpSZ4k1npJOsOkl0990aOR7Y
	IfcBJpr7ydcxhyAw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=iTA4Qvwy;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=2+6PpG5E
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727119232; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kl2d+CZB6CgaqLrv2yHE0GbyB4cwMtXMquA2i+yIlaQ=;
	b=iTA4QvwypVowiZbxHah/isg1ZaHi2NDNBrYhTGrzxQeWUv1vWOzvP7dVU4UsrAzoKaNbie
	ztD8VaJw0RoxedvbDzCYhMn6F9y4BdH7CMk3ENiCI89500Olxo8HKqs6vdJExJkUWpBp3v
	HjcPeMO9tdIOx9slYFe2k0G43xLKEyE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727119232;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=kl2d+CZB6CgaqLrv2yHE0GbyB4cwMtXMquA2i+yIlaQ=;
	b=2+6PpG5EXcfZDraegJ66F1o1TMzzcNpW/0/dLuXQxPykk7xTKXvfnaw4hH3D9QuPr+Ihsd
	atig9cHt+/sZpsCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 9780A1347F;
	Mon, 23 Sep 2024 19:20:32 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lDfZHoC/8WZANQAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 23 Sep 2024 19:20:32 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: Guixin Liu <kanie@linux.alibaba.com>
Cc: axboe@kernel.dk,  asml.silence@gmail.com,  io-uring@vger.kernel.org
Subject: Re: [PATCH] io_uring: fix memory leak when cache init fail
In-Reply-To: <20240923100512.64638-1-kanie@linux.alibaba.com> (Guixin Liu's
	message of "Mon, 23 Sep 2024 18:05:12 +0800")
References: <20240923100512.64638-1-kanie@linux.alibaba.com>
Date: Mon, 23 Sep 2024 15:20:27 -0400
Message-ID: <87wmj2xjlw.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: D29761F390
X-Spam-Score: -5.01
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-5.01 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	DWL_DNSWL_MED(-2.00)[suse.de:dkim];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	TAGGED_RCPT(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,gmail.com,vger.kernel.org];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email,suse.de:dkim];
	RCVD_COUNT_TWO(0.00)[2];
	DKIM_TRACE(0.00)[suse.de:+]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Spam-Flag: NO
X-Spam-Level: 

Guixin Liu <kanie@linux.alibaba.com> writes:

> We should exit the percpu ref when cache init fail to free the
> data memory with in struct percpu_ref.
>
> Fixes: 206aefde4f88 ("io_uring: reduce/pack size of io_ring_ctx")
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>

Makes sense

Reviewed-by: Gabriel Krisman Bertazi <krisman@suse.de>

-- 
Gabriel Krisman Bertazi

