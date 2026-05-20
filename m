Return-Path: <io-uring+bounces-13454-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id CHfYFjK9DWrH2wUAu9opvQ
	(envelope-from <io-uring+bounces-13454-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 15:54:58 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id B80B158F219
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 15:54:57 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 101F631D7117
	for <lists+io-uring@lfdr.de>; Wed, 20 May 2026 13:46:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DDC3A451F;
	Wed, 20 May 2026 13:44:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nOAHALwQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3WlxtjKH";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="nOAHALwQ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="3WlxtjKH"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723A23E316B
	for <io-uring@vger.kernel.org>; Wed, 20 May 2026 13:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779284687; cv=none; b=skM4f0GGfBl0/OUIxfLFVsqMYCEYTG0NyyuOll2flTMcQCikZCRAckH1xS28bl3qoLI/5uwiV8z44CRwr5U8RLPOQ7GAjY/BIYF1+zDPQ28RnkPWcJMN/z9ALA0NrDloXzML9LQEao0yUoeZwtdgvRmZetbWX6kOx72lac4gkHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779284687; c=relaxed/simple;
	bh=CBkBjWF2U9i1hAyuvHvFpgcIRwB887VXlj66qI6/pVk=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=DAdg4kq3wRl+wG5gCLG8j1FBB5UrLVIGvwCnxQVT4KCcsjFRSZB7z30d2HY0Oo0e8m1o0unp/VZo2nSRgS+aBlKxT9p+yQ5qE5GwoIKbUvJYEGSA5T5SiiCFtdkdosDfX0fRO7TQyJUVm+vtk2S3CtYH6UFJNVyZ9cU4tkRQMIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nOAHALwQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3WlxtjKH; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=nOAHALwQ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=3WlxtjKH; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 9FCFD67C46;
	Wed, 20 May 2026 13:44:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779284684; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1QvndRKG+wjMDMiVEpz2P3exRb1yxggYPS8pbhVSEc=;
	b=nOAHALwQAyV1lVbapwaD5LKurCfEkwSJ34CVGJ67WLx8qmZFzh1rdAl6LzwuvTUTDt7CIm
	3S00ATDzewCN8ohxellPCMsCtdifSKuvyysfSDuo6E1F7nUhC2BW6t8e9leg2DW5RYYvFh
	hXEPxCfN9hb9+tr9kmmt5sLBP870SLo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779284684;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1QvndRKG+wjMDMiVEpz2P3exRb1yxggYPS8pbhVSEc=;
	b=3WlxtjKHJ/HDIcyOc5G+oPIrjtWZIEKN7Aifb6oiY5PIzStSsOdgIZiRxVlKAxmsJlHweF
	C+LSIS0TY92FrWDw==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=nOAHALwQ;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3WlxtjKH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1779284684; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1QvndRKG+wjMDMiVEpz2P3exRb1yxggYPS8pbhVSEc=;
	b=nOAHALwQAyV1lVbapwaD5LKurCfEkwSJ34CVGJ67WLx8qmZFzh1rdAl6LzwuvTUTDt7CIm
	3S00ATDzewCN8ohxellPCMsCtdifSKuvyysfSDuo6E1F7nUhC2BW6t8e9leg2DW5RYYvFh
	hXEPxCfN9hb9+tr9kmmt5sLBP870SLo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1779284684;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=c1QvndRKG+wjMDMiVEpz2P3exRb1yxggYPS8pbhVSEc=;
	b=3WlxtjKHJ/HDIcyOc5G+oPIrjtWZIEKN7Aifb6oiY5PIzStSsOdgIZiRxVlKAxmsJlHweF
	C+LSIS0TY92FrWDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 96C3F593AA;
	Wed, 20 May 2026 13:44:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id kmDJJMy6DWrXUAAAD6G6ig
	(envelope-from <krisman@suse.de>); Wed, 20 May 2026 13:44:44 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: "Fengnan Chang" <changfengnan@bytedance.com>
Cc: <axboe@kernel.dk>,  <io-uring@vger.kernel.org>,
  <linux-kernel@vger.kernel.org>,  <peterz@infradead.org>,
  <rostedt@goodmis.org>
Subject: Re: [PATCH] io_uring/io-wq: avoid repeated task_work scans during
 teardown
In-Reply-To: <20260520031221.83210-1-changfengnan@bytedance.com> (Fengnan
	Chang's message of "Wed, 20 May 2026 11:12:21 +0800")
References: <20260520031221.83210-1-changfengnan@bytedance.com>
Date: Wed, 20 May 2026 15:44:36 +0200
Message-ID: <87wlwynqkb.fsf@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.51
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[suse.de,none];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-13454-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	DKIM_TRACE(0.00)[suse.de:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	FROM_NEQ_ENVFROM(0.00)[krisman@suse.de,io-uring@vger.kernel.org];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,mailhost.krisman.be:mid,suse.de:dkim]
X-Rspamd-Queue-Id: B80B158F219
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

"Fengnan Chang" <changfengnan@bytedance.com> writes:

> We hit hard-lockup reports from iou-wrk threads stuck in

It seems like a soft-lockup instead no?  From your description,
eventually it solves itself, the task is just uninterruptible while
contending on the spinlock.

> + */
> +struct callback_head *
> +task_work_cancel_match_all(struct task_struct *task,
> +			   bool (*match)(struct callback_head *, void *data),
> +			   void *data)
> +{
> +	struct callback_head **pprev = &task->task_works;
> +	struct callback_head *work, *next;
> +	struct callback_head *head = NULL, **tail = &head;
> +	unsigned long flags;
> +
> +	if (likely(!task_work_pending(task)))
> +		return NULL;
> +
> +	raw_spin_lock_irqsave(&task->pi_lock, flags);
> +	work = READ_ONCE(*pprev);
> +	while (work && work != &work_exited) {
> +		next = READ_ONCE(work->next);
> +		if (!match(work, data)) {
> +			pprev = &work->next;
> +			work = next;
> +			continue;
> +		}
> +
> +		if (!try_cmpxchg(pprev, &work, next))
> +			continue;


IIUC, you could ignore the cmpxchg here because the following loop
iteration on the caller would catch it and retry.  In this case, it no
retry in io_wq_cancel_tw_create, which looks weird.  Did I miss something?

> +
> +		work->next = NULL;
> +		*tail = work;
> +		tail = &work->next;
> +		work = next;
> +	}
> +	raw_spin_unlock_irqrestore(&task->pi_lock, flags);
> +
> +	return head;
> +}
> +
>  static bool task_work_func_match(struct callback_head *cb, void *data)
>  {
>  	return cb->func == data;

-- 
Gabriel Krisman Bertazi

