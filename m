Return-Path: <io-uring+bounces-5160-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A194D9DF351
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 22:40:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 664F01620BA
	for <lists+io-uring@lfdr.de>; Sat, 30 Nov 2024 21:40:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 600D91AA1E2;
	Sat, 30 Nov 2024 21:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="cfYz9N9i"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58097132103
	for <io-uring@vger.kernel.org>; Sat, 30 Nov 2024 21:40:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733002805; cv=none; b=Q4NXVylACYnhMdw0480w7gjU4HEG/n9DU4dV9u9ey0cSYfdx05QTFR382r3wPO20+dzJYJ6uuoVrUw9xuDRb2bemVgQ9wSCOWIwDdHMlcr1bkXCtAtJqhZsWkBG3e2dIcFnDfayHAk/sx+m5y2ju4X1NxTfhtSXQeYYi1WB0BKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733002805; c=relaxed/simple;
	bh=QIh5LPdBUUadt5QzHZ7uB31Jw1WDhsvFhK956BLp8P8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Sio0OTuoyK1OX3gGKVMZXC3nyPttPZPaKP2x5+My/TIVkNTidruPwBSg5HLGrBxkgVOlvTS0ajR15tfIhRQe0MQwR8yQhg5a1dV6QLstqy3ha4AsTPGHJvcfUna0qrBYFw8IL2Nl+090cq23HENG9wL6NbIdP3AHin2Yg1RL+po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=cfYz9N9i; arc=none smtp.client-ip=209.85.208.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5d0c8ba475bso1165854a12.1
        for <io-uring@vger.kernel.org>; Sat, 30 Nov 2024 13:40:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1733002801; x=1733607601; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Pw67/dEHvgxdkhQ24l1tOBa/DcJdy1WA/fl+pLzPNUA=;
        b=cfYz9N9in0vmgdwIrqcSTstnLikT5P72iDImi+nBcD2C6fPm59TYUfGBgngIyfxKxq
         YqI+bv/IQhYgp4mjktHly3iz8cLGnXQFoZ90u6XmydEKRPCwMrofLR7t0zyBTGdv1peq
         rCk6V6e4g0n+86Pwddqmb2OFMqJjiNLEBPXY0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733002801; x=1733607601;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Pw67/dEHvgxdkhQ24l1tOBa/DcJdy1WA/fl+pLzPNUA=;
        b=xDF+onspOUH6QZDqy0Nnib9kh2xCPDKG1QAKxVCfy9m+zQDPWL2cwG+gmA3tlLW3vs
         mdPzXK2fP47gwQjZ97k09EToZuXuOY3wXm2qfpR3ApiyD7xT52PFvJa68ngu0fh0JodJ
         SFqC7q73y+DOvlDtV5YRSRT8UHmGiG9YktqZP/GUiL+yBxrNv2n9iWH1nQtvz4TeBjNx
         qNNUla10LaBxCVVCcx4GAPyV1c1PPvmQdTYU+f6dWiNanRBQFKNyyS7qplgpCR4fXR9D
         5JyajF0vo4f4U+9i7L4XshKeVYmJq398vP+JGB0CRPJtAuUmGD/VB/n8YfEu6a/GKcv2
         4hcA==
X-Forwarded-Encrypted: i=1; AJvYcCX6hJ+/RfNKARgLHyryE0Y6voXxV4ZYz7OUaeUgnxh0INhMI0opc2EKfQ0gs2T+wci6mHwzpOH1fA==@vger.kernel.org
X-Gm-Message-State: AOJu0YzYxhyiUvUevxJ8sf1S4K6kQgSAOQLMrmXSXz7or6dSMS/8No5U
	noKGLX8KezZLle7SmeVFHa3cNWA0Qvsrlx8ub7BOTsdKtCQEyACHUWO9+q9HlAUcMnwrJ5b0KYr
	Rw80AfA==
X-Gm-Gg: ASbGnct/hE5bc64g13T+qnli1hcvEG3rrWE3yWUHjIgyo7bhKSKk+/0CEYbAZzO9aDE
	RsjbvpC8cIU28Hi3RATRBLXlcaAL14YVBcWzSEXLgSS/uaMrvvna1GaBdZ4p/JBP39EMzwHKSlH
	eu0x9lXh3ZFRyvWYm9C2HfHklABKvguFyzZONiGQQRdUy7ABgwlqnIE/VGpFtvIftqjFKKgbqxu
	hid67itTeBQB3GMKlJ7ipc+Vn8fGztdqYHqOnf+WrMLZNe5Ozi5o2Wq11WILTLpuc/P5xGyvakN
	aSj4jXo3BfR5RqZqa9KZA5Ei
X-Google-Smtp-Source: AGHT+IEvOzYzDE3OK1aWwXm/OR7uEa8n1PqjlBFhhOgiLnBlXaEoH+f2QL5Hu5OxP9ScIVikdF4peg==
X-Received: by 2002:a05:6402:3506:b0:5d0:d63e:6f43 with SMTP id 4fb4d7f45d1cf-5d0d63e7053mr1386792a12.17.1733002801624;
        Sat, 30 Nov 2024 13:40:01 -0800 (PST)
Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com. [209.85.218.54])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-5d0ca3a644csm1071060a12.33.2024.11.30.13.40.00
        for <io-uring@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 Nov 2024 13:40:00 -0800 (PST)
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-a9ec267b879so436313766b.2
        for <io-uring@vger.kernel.org>; Sat, 30 Nov 2024 13:40:00 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCViupNLAH77IDMXXkthOFLpEfqNK9TAJFHECFr5TIfa2fs/HxSWDqPC04BNduqbTeItWCJCRRBBtg==@vger.kernel.org
X-Received: by 2002:a17:906:3090:b0:aa5:1585:ef33 with SMTP id
 a640c23a62f3a-aa580f1ae0emr1355585766b.23.1733002401515; Sat, 30 Nov 2024
 13:33:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241130044909.work.541-kees@kernel.org> <CAHk-=wjAmu9OBS--RwB+HQn4nhUku=7ECOnSRP8JG0oRU97-kA@mail.gmail.com>
 <202411301244.381F2B8D17@keescook>
In-Reply-To: <202411301244.381F2B8D17@keescook>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Nov 2024 13:33:05 -0800
X-Gmail-Original-Message-ID: <CAHk-=wgSsP6w=wLeydMiZLjNwDaZrxyTx7MjFHo+BLXa+6YtVg@mail.gmail.com>
Message-ID: <CAHk-=wgSsP6w=wLeydMiZLjNwDaZrxyTx7MjFHo+BLXa+6YtVg@mail.gmail.com>
Subject: Re: [PATCH] exec: Make sure task->comm is always NUL-terminated
To: Kees Cook <kees@kernel.org>
Cc: Eric Biederman <ebiederm@xmission.com>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>, 
	Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
	Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, 
	Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, 
	Valentin Schneider <vschneid@redhat.com>, Jens Axboe <axboe@kernel.dk>, 
	Pavel Begunkov <asml.silence@gmail.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Chen Yu <yu.c.chen@intel.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?B?TWlja2HDq2wgU2FsYcO8bg==?= <mic@digikod.net>, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	linux-hardening@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Sat, 30 Nov 2024 at 13:05, Kees Cook <kees@kernel.org> wrote:
>
> Yeah, this just means it has greater potential to be garbled.

Garbled is fine. Id' just rather it be "consistently padded".

> This is fine, but it doesn't solve either an unstable source nor
> concurrent writers to dest.

Yeah, I guess concurrent writers will also cause possibly inconsistent padding.

Maybe we just don't care. As long as it's NUL-terminated, it's a
string. If somebody is messing with the kernel, they get to the
garbled string parts.

           Linus

