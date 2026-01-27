Return-Path: <io-uring+bounces-11943-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cNsJAKr2eGnYuAEAu9opvQ
	(envelope-from <io-uring+bounces-11943-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:32:26 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id 27DE19879F
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:32:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 97DF2300138B
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 17:32:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 02B82309EE3;
	Tue, 27 Jan 2026 17:32:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VKKUZ2xc"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EA90221F39
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 17:32:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769535140; cv=pass; b=HyJ+/EujPmdp5XqNlbCc+mEAXZhYkjmnW1drJQmwm6MEhkedzWNpYqKtESgtlnHpQ/oVgwwvvI7QaZfVAEMNswqFyhJFAOMZLBjXNRuQXqKr3rOvJZHUjmc4jcpfdg+BTom2m/2UXxFsa579NTbko5NFUKM4RwvSai3H+xpXc5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769535140; c=relaxed/simple;
	bh=agbBtWV6+bRJAhbybtzVUREZStWle+84gx4fgR0aQj0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kGBSe8oHcgGHzJKRNs4Wx9FNPjl6yLOCr1xvfbcUlahNoNQ+3WzkrIsPwCdZ7IWVwEG0GJFPoOJm2853lVOP2g6dGHS+bT462jOKTVPpEdR2+WhG7gAoRn0/YLEE1I5isRXyNrE0ZgbfUQs5/5U343qQh+RBiuaF9lEfLybSG7Q=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VKKUZ2xc; arc=pass smtp.client-ip=209.85.221.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-435903c4040so3680047f8f.3
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 09:32:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769535138; cv=none;
        d=google.com; s=arc-20240605;
        b=dGKZYSMeeUeSInR7PvtcKXzxmAWm0icV0YUmwfS0zlNaQEYG9Z58LWgtNY9OpKa3hP
         UXJZrSO68QiWVJ39L0K/4l9FeREO63Yzfb4j8SfB8ycYJhgs7exQAPEhjIcHZX39MWAO
         KjHPRhQYIjYIBwLez97d6OQrV5/wBY5lJJAcUk96U2pqdj4o2GBvO3INeSz3mSpELf5Y
         y0FS2fLoH5VixZ50CVgmlDVpKxszcas68jvBimLRxBH6rVtBw7n6sYr0hgV5/aSNJCTe
         4r42UdqKugU/qXaKscZ3nQUy3ecX0NWWA5gYiYQDOW8HQLd/fJ9sQkO/eVclSFaxr4/R
         Q/Pg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7AzXtpBQRjUoOHERZB34kGez9UJ4aKAkoQg2fodp448=;
        fh=XYp/eX7jR6pjSjAplpsP6Eq/qusT7KS/rrGls9fwNUI=;
        b=kpabe66VQno0uCwMp5PjVXcvnfCO1dyf2baQkG8B0lC2A8fjagLIm/zbgS/k+CuuCJ
         gol3/+0jxd8NRr6VuCXxmziDi1igXKnf3+0fMD9T+EUO4/uAXSfKFpxF1v2ee9hLqVl5
         3SuOKYkTPqvSWjmLOyJfWYXRetlxTm5/6CS02OzqK65O1dY5AYYX0r0sOuxn5MJb7TJW
         ApdbmR7/oSB/RFkuFetjYuwOzWwVXYogAFZLavrB+ptVfgzwkVu42NwBbj3xOeN+a2M6
         ya8O7c1ZT0W8/k9KIRLibudFeAsiG1arsqGorw9dCtQocsRZZf5mArZs52EHs7zCi4hS
         w9Nw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769535138; x=1770139938; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7AzXtpBQRjUoOHERZB34kGez9UJ4aKAkoQg2fodp448=;
        b=VKKUZ2xckyvp20I5Fg4MYIfBo4p7rnweJ4t1MscNBGl/KAP9y+0ZJSsSnNMu6CtfNb
         AAqHiDYDZXQnjBY+gCkRojMVfRJkmbxxQ6/7NfqIIxuewjEU9OUhJB9jf+PVdg+jIeyb
         es7AaFswcgptq3JSccVGZvzki6ubXT6GsvuclYsp2CQ757VeN8QkUfUdOM7iouEeWuzR
         WSsIZeQUqEElsO7tvsOW5Pp9QgIci0dutCPJGlh/zeAHBs8KsWhEn1b5hGuEq3EAQIsX
         hQ4FH7X5uCVMgVny9/BxW/t+4f/ElgfCSMNFZnnKol2HpTK7yFpfNMqTBuAU6QEBacsT
         u68w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769535138; x=1770139938;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7AzXtpBQRjUoOHERZB34kGez9UJ4aKAkoQg2fodp448=;
        b=ZPImPwBCil5oQMQYm3/QA6N0JAZHAuj0BAVPwIzrFyVYIj4TkS755MfulC6LFL5oMM
         Ogh9dNeW1QAC2Ee3aeRg1GYwb0EsOfGrWmM7bKmOfqpRhARTTfcoSuUZ4vDf4UyZ57MZ
         7rU+BQWOaiiE1B1ofdrYOCqG1pDBWXd/HvPxRBMdi0OOV+E6DA006/qYAKBIVB6Ob7+E
         YAkyOzlNzIvvfTqEmQKeR9dJOVE+cy/kQD8ZQL6/LknJJwEmVdVCAE7BXIsVj/StIXKa
         W2venYVFK6sQ8mSZU6I74KneZkxRJ2RBUrOyPonp1paXyDcL6Qrgzcbib68DJJUrm+I2
         Iwbg==
X-Gm-Message-State: AOJu0YwekRC7wB+aQT5e8QQNtO9JtO+zE2b2FDfHcdsZeG3x41XKhcuy
	nl5UbkHDVzaHPyhHxqFkHfcxsrtduz64FJSuywlQx5HYTlxiae5TGbLdBrIJ9BqJOwZovqaNCti
	CHVOw/wsmrr2NmDEfPwuXucbJC7fmlN8=
X-Gm-Gg: AZuq6aL/SR8cDHpZ4lPnHSa/R319At8IQ+F804iAyVNUV1419JC1sl7Sz/dDpSSM3tk
	3+B7ti032XUicqt86A0qSfYKFZ3HsuuGxwq+YIVzT83YnDv/BhhVYUsoI2CkJGF9OV7WfCgSlIn
	41JL5gGGMcfBQfHcbaCaVyrtSl2FvS1ouUzSE4JdG8/KmrNjbQ1bgeV0nSvLmFfT/SjqHj4EsxW
	1vTPix8QebW56gdtXYb0Cn07k2wf/Y51HzYcyOWYFeiKhr1GoWbiCWsRFWMA2bnrOiTaSfOkYhQ
	kGcdAH5eXbvvVrXH5hhOw+/djD6YEEc70rqe/O8F6YEwVETuOBjUKWf1uQTzdc6S7AKit6r3lrR
	799rh1fKrEgDbm0Wgfw1dUGy4
X-Received: by 2002:a5d:5d83:0:b0:431:b6e:8be3 with SMTP id
 ffacd0b85a97d-435dd0b69fdmr4117395f8f.38.1769535137438; Tue, 27 Jan 2026
 09:32:17 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769470552.git.asml.silence@gmail.com> <b766b428ec90862d69c9ab843dc89b6d0a017628.1769470552.git.asml.silence@gmail.com>
In-Reply-To: <b766b428ec90862d69c9ab843dc89b6d0a017628.1769470552.git.asml.silence@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 27 Jan 2026 09:32:06 -0800
X-Gm-Features: AZwV_QiJN977OpVwvJKpxGdEFWEBwGACFC5_ZTxDEFVjE4sOmNBLvONiR5cDr3E
Message-ID: <CAADnVQJcoyJ1hmU_oUcjj=8ewPAPTOZ8eccTutSJWHFy2Xza=w@mail.gmail.com>
Subject: Re: [PATCH v4 6/6] selftests/io_uring: add a bpf io_uring selftest
To: Pavel Begunkov <asml.silence@gmail.com>
Cc: io-uring <io-uring@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-2.16 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11943-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_ALL(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FREEMAIL_TO(0.00)[gmail.com];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[3];
	FREEMAIL_FROM(0.00)[gmail.com];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[alexeistarovoitov@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 27DE19879F
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 2:15=E2=80=AFAM Pavel Begunkov <asml.silence@gmail.=
com> wrote:
>
> index 000000000000..7a170cb2f388
> --- /dev/null
> +++ b/tools/testing/selftests/io_uring/types.bpf.h
> @@ -0,0 +1,131 @@
> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> +#include <linux/types.h>
> +#include <bpf/bpf_helpers.h>
> +
> +struct io_ring_ctx {
> +};
> +
> +struct io_uring_sqe {
> +       __u8    opcode;         /* type of operation for this sqe */
> +       __u8    flags;          /* IOSQE_ flags */
> +       __u16   ioprio;         /* ioprio for the request */
> +       __s32   fd;             /* file descriptor to do IO on */

1.
No need to copy paste. Just include vmlinux.h. It's there.

2.
drop KF_TRUSTED_ARGS from kfunc. It's a default now and this flag
was removed.

3.
add a runtime logic to check that the return value is either IOU_LOOP_CONTI=
NUE
or IOU_LOOP_STOP or instruct the verifier do it statically.
Otherwise it will be less convenient to extend to other commands,
since the way I read it IOU_LOOP_CONTINUE =3D=3D 0 aliases to any value > 1=
.

