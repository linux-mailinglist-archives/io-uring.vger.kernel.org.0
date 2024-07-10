Return-Path: <io-uring+bounces-2482-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id ED22292C7B9
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 02:57:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 29E4C1C21BA4
	for <lists+io-uring@lfdr.de>; Wed, 10 Jul 2024 00:57:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2677A23A0;
	Wed, 10 Jul 2024 00:57:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dtxNH/Ic"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A05164A07;
	Wed, 10 Jul 2024 00:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720573049; cv=none; b=b87q6TiYAmwERkfFD9ZkGOR+qAIyTrkG//eXLzSpG8VfnYVV00tu1jATn9e/8MbcmAsBFSDEphU1toZF7UjULLAHHzNs70m6mMOeNycUlsqBPiJEkSGdKJnT1DHo/2fa8JVuHqAWs2glQgELkJa3NhNDwkB6HJS089yT4jwDnjk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720573049; c=relaxed/simple;
	bh=B2IJUWG+gIY1F0/nl3PBsnRoD1Lqo2RSfjArrbG8HaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=jC/ziSWjCQUjxs01FbjGrCWoS+UQGerTJ25t6OiLXpKzOJUiZlaGcw/HoLYnqti2mPrFw//ykdAN7NMz1yp2RHPe4gm6DbPlK9Zve/jJw2b1YBjjjJJrR6bhkecCkEdZthThnlKsWCRysYnSZNrU0a9kUW+9LHg6NsztnBTbv3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dtxNH/Ic; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7036815bde7so1764372a34.3;
        Tue, 09 Jul 2024 17:57:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1720573045; x=1721177845; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YqcG/O7UO17pKVeqS9vSTR5z7c3JMkKO7hnG3tldC4=;
        b=dtxNH/IcflGUjibj8v5KNdAAa8moMxLqmGzniUtyEy+mc341k0Q4xZdRlrw9gommVe
         H85eLboWFDkB4bxKvZ6VzMUMHJdibrQbcmJymDLBfTcAUl36ruILpnYRraBNgTI2OCxU
         JrnsylFTP7wNaOVxC1fjXLwl/aSYkHMlxaBf8556sAuk+9ejtF35TvJ2lEDYiOo3PHVE
         NIFe87cybBZIAyBZB5jF0F+6XfD90yR296Qoq1A3B3rQ6iK5OBHGsUbym0wJCBtL5Qik
         5dCjPMtkZJ3k8wwHp/iatBCz9s0kiA2stk5n7c2GdtywVI9fkTskLUSsmfmd4JaMAItb
         I+nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720573045; x=1721177845;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2YqcG/O7UO17pKVeqS9vSTR5z7c3JMkKO7hnG3tldC4=;
        b=eysRH6HjzLzluBYmsF0hA0s2v6hbT9jVu7WndOqiaq3J+10ZhY+dJPGknt1/pObp49
         V3I+2zqgIJoSMPOqz3cDfWdMqnC1svgA9S0wOJXzG7VHj8BKrMIASJIoJY9EPFnqgEkW
         gODatId87czaL50qSgc/ZeplQsLlcT8uBWBgU6EDPM6JPafihZ9HPAwjh+M+1xF71ArT
         dvmny2XDhZ6MVO6BQJx+hWiFaljtYp7aQQZr0EXMmMOZUwY68Wcv4oksIWRTnscFNe9H
         GZEs9FZX+RrITuwdAONS7OLzSJ1lncgj09WtqNP8lxBu+i28+UMYPuPJb2WKZxjLUtAv
         LYMw==
X-Forwarded-Encrypted: i=1; AJvYcCV9o9QQCClpcHwIKO6YdXLaO75o7B4ZIroQVjHtUIoPI810EWpmxTbqcZ22bCEihVoOxmIaK6pTq6ZyuWVD7lTw9+5tnV8AbYR4oYSq
X-Gm-Message-State: AOJu0YydSTC5TC6XFo9yUz/bw9tQyAZ/wC29WHSIUgv2aAkgeEkIllDW
	X8HGeQVs5DfRsA3Yb9ASzC1ZF0/TiMpr+lh5/NIBANyHg0n4477q
X-Google-Smtp-Source: AGHT+IGCdW4ebx+zL0Pukp6i4b9YkL+Fx//qJ6Wqq2XyXbYfl7OoNWXIXyjdewNDL0PDLXDB5jkExw==
X-Received: by 2002:a05:6830:1648:b0:704:4938:e4fb with SMTP id 46e09a7af769-7044938e726mr933070a34.24.1720573045525;
        Tue, 09 Jul 2024 17:57:25 -0700 (PDT)
Received: from localhost (dhcp-141-239-149-160.hawaiiantel.net. [141.239.149.160])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-70b438c70a4sm2467638b3a.83.2024.07.09.17.57.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jul 2024 17:57:25 -0700 (PDT)
Sender: Tejun Heo <htejun@gmail.com>
Date: Tue, 9 Jul 2024 14:57:24 -1000
From: Tejun Heo <tj@kernel.org>
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
	Oleg Nesterov <oleg@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>,
	Tycho Andersen <tandersen@netflix.com>,
	Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
	Julian Orth <ju.orth@gmail.com>,
	Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH v2 2/2] kernel: rerun task_work while freezing in
 get_signal()
Message-ID: <Zo3cdEMZVOJcseWm@slm.duckdns.org>
References: <cover.1720534425.git.asml.silence@gmail.com>
 <149ff5a762997c723880751e8a4019907a0b6457.1720534425.git.asml.silence@gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <149ff5a762997c723880751e8a4019907a0b6457.1720534425.git.asml.silence@gmail.com>

On Tue, Jul 09, 2024 at 03:27:19PM +0100, Pavel Begunkov wrote:
> io_uring can asynchronously add a task_work while the task is getting
> freezed. TIF_NOTIFY_SIGNAL will prevent the task from sleeping in
> do_freezer_trap(), and since the get_signal()'s relock loop doesn't
> retry task_work, the task will spin there not being able to sleep
> until the freezing is cancelled / the task is killed / etc.
> 
> Cc: stable@vger.kernel.org
> Link: https://github.com/systemd/systemd/issues/33626
> Fixes: 12db8b690010c ("entry: Add support for TIF_NOTIFY_SIGNAL")
> Reported-by: Julian Orth <ju.orth@gmail.com>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>

I haven't looked at the signal code for too long to be all that useful but
the problem described and the patch does make sense to me. FWIW,

Acked-by: Tejun Heo <tj@kernel.org>

Maybe note that this is structured specifically to ease backport and we need
further cleanups? It's not great that this is special cased in
do_freezer_trap() instead of being integrated into the outer loop.

Thanks.

-- 
tejun

