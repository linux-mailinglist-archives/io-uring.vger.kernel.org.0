Return-Path: <io-uring+bounces-13356-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id qIq+NqMrB2oLsgIAu9opvQ
	(envelope-from <io-uring+bounces-13356-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:20:19 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 54585551448
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 16:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 53AF73040C55
	for <lists+io-uring@lfdr.de>; Fri, 15 May 2026 14:14:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C358D48097A;
	Fri, 15 May 2026 14:14:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b="f9gkMcn0"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-yx1-f45.google.com (mail-yx1-f45.google.com [74.125.224.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6359D3CC7C5
	for <io-uring@vger.kernel.org>; Fri, 15 May 2026 14:14:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778854489; cv=pass; b=o9hJTt1mfuduBaQMr7uON/e3aS7bLT11ZbbTl4757Brj+nO2+ppuUCSwTBUj+O0c3Jj3Ztd15dfI4XA1E7ZsgeeJjLftwt2kTw83f11fIIfSf0HzcB6tSIURtw0iPwHyWEHCP2CicqRp47KGDrDI6NFjPFggExbHVB1ltBx6gdA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778854489; c=relaxed/simple;
	bh=JJFMGNt3smn/nRo+9rSXfk4rP7ZcWNohnOcxUFIEH/c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BnnNNQ0/yJ8NMP5UJW0N4kHnIcy6Wd0IAlnZ5wODl1RD7xGi4PveIsHYfGeW8qcWBYwa7HJ0z+rzQ2hW2TYub0CPjfYF/Yky9MW57AgRn6Tvq/nDtxQkrduAHrxQsSH7v0BMU/BlPwFyGcugSDAEixf5Zmyi41efGRowUJN0ymg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org; spf=pass smtp.mailfrom=bitbyteword.org; dkim=pass (2048-bit key) header.d=bitbyteword.org header.i=@bitbyteword.org header.b=f9gkMcn0; arc=pass smtp.client-ip=74.125.224.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bitbyteword.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bitbyteword.org
Received: by mail-yx1-f45.google.com with SMTP id 956f58d0204a3-65c477a3278so11742528d50.3
        for <io-uring@vger.kernel.org>; Fri, 15 May 2026 07:14:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778854487; cv=none;
        d=google.com; s=arc-20240605;
        b=bzxm0fzr+EjOItu9WOcPl+beKs0CYFUqnNkEEcWT/WF3j1yTa05x+ShzO/5AyBHxbw
         l54wm2X+/498Tk/uJUkx2080VwZYFQv21xu0go0PSO11uQBRBkHp+tWXF6YWuv7Y5z/l
         Ha999L7ztVW0515k8H1NskNvts7Vpd6gT8SiiAOmkj9L6SA4wZQjFpp7HtDk7ybekMlb
         a1UjFMfpMbdbbbAhnt3wK4TlGBuOGXgRpEgR6o8k83Gt3TuMaLJfAcjoZfEpsy5d49D6
         Fo6SYOJpxxuB1Tf9DeOnqAf2nta222tTkUZNJHAFZtKK4Z7PVlotGkkPScCPmBwsTRXC
         oIhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JJFMGNt3smn/nRo+9rSXfk4rP7ZcWNohnOcxUFIEH/c=;
        fh=SjoEcHsaSGbExf5n+EIzxtSD3492n/xLQy0xlPmAS0o=;
        b=evG7DuajHLzqLfNLinBu3tLdckIHuAyGzM2c8cbDl6uU2F8SUw4rJXOezigiRilw6E
         fWu4oS6HSzKpUNlEldVUOAHxxVQCfuQQBrcAewkKaUULc366RWsrSABZ/HvTpGlb3OA+
         SUIskPdM847srq/kbe3TYjZa2mt1e0gaREf4WfOoBi4ugUE1nzRjgC9YTPsLqYSrx3Ms
         cN4Rx33ciMLL8Bucpktm7kZoEzfnbDGykbJuCD6rfoH9gc1JjR24FICQorOB1emFSoGD
         eN6VxRLKmgvirgfLbRmkJk27XUycCWoyS/feiCvCAVwvxc7AZjD9k2FSUXTwWBaBc4Xx
         fdBA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bitbyteword.org; s=google; t=1778854487; x=1779459287; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JJFMGNt3smn/nRo+9rSXfk4rP7ZcWNohnOcxUFIEH/c=;
        b=f9gkMcn0+zZUc4O+wXYzpeqXNTjdOOUXo5oQRYPfrZ9kQaKhILsKiWalhlD3yFcWmx
         OG2ZFnV6n0Y7v7lkKl6zKaLjGNvlC0n7oWoJk/xos2QeZMlqbp5yl+HiT6W7H8uarXDg
         MmOqwN5u7HgKlcmgNhE7k5IMMUhogHhYwIAKqOhtjMSKyXfAQdDlAd9vdwSJj2YRBCqZ
         KqxsMtNPRGpbaSrHhaBacDaO1MexeRULlACItSx0EdMx3L8p1Oo3A+h88xqV86ylKCpJ
         CN4fBylVApV35Ov7rMJlG2zLRHSXo/aOfibfp+4gt0HDHPnAfVfXtyE5DeqaBykLyfNp
         KQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778854487; x=1779459287;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JJFMGNt3smn/nRo+9rSXfk4rP7ZcWNohnOcxUFIEH/c=;
        b=lediKrxj7bFuzmpl06D0FNr+vhugytbLjqJsu/IKksDTi89Y58DU3EglH2fzw+gaAB
         WN/aoGJHbweecZ6ir9TiwyioThNalr78JQVUqww2NgMUm7CxY4IRQ3DaWkDRitRfi+9D
         E891z9lHJc8ouJ7q+6sYFKrCxNw5xseBsvfoqefDrfk/SaFpaZwP2Sd9FkDETXuNY8rc
         vqfAbRjBAE48b0xarUXIlhjLtxIjpTRYuTCceVXFEb9E5mXg50i30ZAjl5nF1ys7iIWn
         7vvfbGCCk2G4S7Qgi8Ps5pjVPkeGaptDGSHuttuDOt9YnJjjK2tcUbV8sAgZVEWhCfXu
         I18w==
X-Forwarded-Encrypted: i=1; AFNElJ+Mxb8XN/33t1PnaaZiVxN81C/2CoTTfPI7idgeRvqK0fJUCZlSLcP0HJfang8JZveTXzgbiSSvVg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzv93uep8RpS4ardI7BfwUuTECNeBnGM5vL+aiWf9PjAoOECbRx
	3g1+G9qAATVQ+KKtpQ+edAkcvRbIOjju+siAWAjFydvNVFN56u+h5fkBj6tCOrtVE8lfXsxk6fr
	kQdFwC33DZ3gHsiXCh5usZq7AuNp5H/eB7WmpPtWYWQ==
X-Gm-Gg: Acq92OGB8PsZ/h0McGEzc7/VW27zly/LUw5f5b0HzZKqnH9zkZfR8iXb3y7Ohgc/fuF
	GQfZrToC4hPF0xn0uJzL0FacTZk/cqD7m47ugn5LUFlYmGQ3XCw++I6T9uiC+jsPRDJ05eBLkJN
	OwEvlbXozmhdd4SCJnyIgOdqmEYA+JHycF+Sb+H1IiSCvi5Fra3p216joOyuFNjL0LbLmBdFDam
	aqdA1+/52SRQLT6xMo8fQj+kuX1UNe8PAQ8+04i7myTPmfn3PK2IAxGkEKbvCIZ/o4hQ4vTvZAi
	rnKQlcdBI1PhGxuAJE74QKaUl811y+f1TREpnp8q
X-Received: by 2002:a05:690e:418a:b0:654:5d65:9ff4 with SMTP id
 956f58d0204a3-65e22674e00mr3815940d50.10.1778854487348; Fri, 15 May 2026
 07:14:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260515135903.2238731-1-vineeth@bitbyteword.org>
 <20260515100448.715589f6@gandalf.local.home> <49e77605-6227-426e-8103-329474bf88f9@kernel.dk>
In-Reply-To: <49e77605-6227-426e-8103-329474bf88f9@kernel.dk>
From: Vineeth Remanan Pillai <vineeth@bitbyteword.org>
Date: Fri, 15 May 2026 10:14:36 -0400
X-Gm-Features: AVHnY4JoBz_kAVO7oVVxjOoTR7W-h3RFbkpi3j0LZXngCIQFZfxRvShyMiW_Km4
Message-ID: <CAO7JXPg+MJXF8smC9qXs93YziJT_amQwWKVW38L7F5XdS9-SaA@mail.gmail.com>
Subject: Re: [PATCH v3 01/11] io_uring: Use trace_call__##name() at guarded
 tracepoint call sites
To: Jens Axboe <axboe@kernel.dk>
Cc: Steven Rostedt <rostedt@goodmis.org>, io-uring@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 54585551448
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-1.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	R_DKIM_ALLOW(-0.20)[bitbyteword.org:s=google];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	FROM_HAS_DN(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DMARC_NA(0.00)[bitbyteword.org];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	TAGGED_FROM(0.00)[bounces-13356-lists,io-uring=lfdr.de];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[vineeth@bitbyteword.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[bitbyteword.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_FIVE(0.00)[5];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,bitbyteword.org:email,bitbyteword.org:dkim,tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,kernel.dk:email]
X-Rspamd-Action: no action

On Fri, May 15, 2026 at 10:06=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 5/15/26 8:04 AM, Steven Rostedt wrote:
> > On Fri, 15 May 2026 09:59:03 -0400
> > "Vineeth Pillai (Google)" <vineeth@bitbyteword.org> wrote:
> >
> >> From: Vineeth Pillai <vineeth@bitbyteword.org>
> >>
> >
> > Hi Vineeth,
> >
> >> Replace trace_foo() with the new trace_call__foo() at sites already
> >> guarded by trace_foo_enabled(), avoiding a redundant
> >> static_branch_unlikely() re-evaluation inside the tracepoint.
> >> trace_call__foo() calls the tracepoint callbacks directly without
> >> utilizing the static branch again.
> >>
> >
> >> Original v2 series:
> >> https://lore.kernel.org/linux-trace-kernel/20260323160052.17528-1-vine=
eth@bitbyteword.org/
> >>
> >> Parts of the original v2 series have already been merged in mainline.
> >> This patch is being reposted as a follow-up cleanup for the remaining
> >> unmerged pieces.
> >
> > This part should go below the '---'. There's no reason to add it to the=
 git
> > change log.
>
Ahh sorry about this.

> I pruned it.
>
Thanks Jen :-). I can probably send a follow-up email directly to the
maintainers to prune this part, similar to what Jen did. I guess one
more version might feel like spam.


> > You should probably also state that these can now go in individually as=
 all
> > the dependencies are upstream.
>
> I think he did, at least that's how I read it.
>
Yeah my intention was this, not sure if I worded it correctly. I will
include this in the follow-up email to the maintainers for rest of the
patches.

Thanks,
Vineeth

