Return-Path: <io-uring+bounces-4307-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 565A09B93D3
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 15:58:02 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 00D741F2176C
	for <lists+io-uring@lfdr.de>; Fri,  1 Nov 2024 14:58:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193BC1A76C7;
	Fri,  1 Nov 2024 14:57:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rqTjhhBC"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3164319DF53
	for <io-uring@vger.kernel.org>; Fri,  1 Nov 2024 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730473078; cv=none; b=FdFs4NdKpMkP5D2bzftjoyeHVmOmaZGQnayB+pdSQAC62wdjMNJ3oG2lY9J9796jYI1ZRkcltEbXbVAXWHScsIs4X4U38G4Gf7dssbeZD3CsXcNzicezsyYfnvdsLQyansk/+vrCedZSDhqtWX1S+nXRwSj27RkzFWoAouqap70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730473078; c=relaxed/simple;
	bh=HAKYWZYx81tzoWdX3VevVxQgSCoKlHjOH/hWoXOy5W8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RX4qwV0fQAp2ZXcQVo4x8hKyq1kVUtDj7VsjtulQJGAgNGwAY75N8ZVSPvHVFmdB2WwyK1vIKWp9jx5Ccu8lg4E8VdekavGHKCFCr5pya9gle4RzvRs/SXWYxQYlXa3sKLFcOgosG80+WDlwcJya6b7N2HIcJRYPUGzKwFVR7E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rqTjhhBC; arc=none smtp.client-ip=209.85.160.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-460b295b9eeso147681cf.1
        for <io-uring@vger.kernel.org>; Fri, 01 Nov 2024 07:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1730473075; x=1731077875; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HAKYWZYx81tzoWdX3VevVxQgSCoKlHjOH/hWoXOy5W8=;
        b=rqTjhhBC9hU+WkOAPWU4RIGn5JxKM31Zak7qWRSJuhvRzpz2bwF4dwzOa/lwXxtCod
         i5lm15CwzfTUIex05xIMHzauDWPmLWJ2/FypGM9rXRcQ1zywN+4+tjfhsjIl0HEiIVZ7
         FC7zkr0qLUv8L66Nr8RDiYrzdXMPNwDu4tyKCJhshfL6SXEK6r42RME1nxs8u8HKEy+Q
         ++TtTI7hdv8M3v3IU42Z7uaMRVOgiX9bk0YikOjXaPLORao1PT1RyaIJYlqwzHVsBqcu
         Qszu/gaPEbNsvEoqS0c7iDVu9Q0wh1D9hm5uOUnCvOTMk2IuEv7p/zwm0DnAJ2by9vsD
         40Cw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1730473075; x=1731077875;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HAKYWZYx81tzoWdX3VevVxQgSCoKlHjOH/hWoXOy5W8=;
        b=nGa/QZa1eqIBTgtcBzzqbircYr1DCStNIGqpiRdgJw9W+Uo9Yu81Bd3Hw3kTMbKLyo
         nqx4d3ExuAWbjTfiiO7nUg7pH6cb0VN3N0m5MTIYr67AdC4OYVdyLndAPKdusP3cBvSB
         dUBe9196LwYOcRWT/drVFqvjJLNIBR6TlduiJYO9d5ttuHRcJtDOKkeN5IrIRrCHbPN0
         tsUQJtVJzGky1WjUov5Xe+TuMQkd7+zV/ves5VYLIc0+O+e4GMAU8tYiL60PsCI4CgXx
         0qL1jcOjQIFJrG4J4FfM71MmNpVTFgpp8N1+L6YrGdYZtXjaQgLJIvg0qvWq+8nQeMgF
         2Wiw==
X-Gm-Message-State: AOJu0YzUmrF2PSKM9UtBbWawkGvjAhEsRcC/dGnIBYD0QktbC4nly8Y3
	+tXtKTOsz4xh+xK4R1WSTrDVnNLwJzNfWXy5cq6nNsmYSFLwr7wibGFPwQ1b+Xble02SzJ9Hzn8
	jTxYAV/QCk7GPq696MWEcAZZd4oxN1poHVpr0
X-Gm-Gg: ASbGncsCOlfDEv8q7VcvDKe6h59BsrySB6ER5L4MMoFIJwB8QQFUQ87SuyYzUjpejer
	lWFvWtlJEb0MCX7bG4DEQgU7jnWkgRB8=
X-Google-Smtp-Source: AGHT+IFsxGUWa4VfPbyiWUamurViNWXHq/tQXiIZJlN6p9X0wZXszbpUZgaUZKOuw2yIZ5QZTxwGURHFCn6Egdnz7go=
X-Received: by 2002:a05:622a:88:b0:460:4620:232b with SMTP id
 d75a77b69052e-462abb290f6mr6586171cf.28.1730473074948; Fri, 01 Nov 2024
 07:57:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241029230521.2385749-1-dw@davidwei.uk> <20241029230521.2385749-2-dw@davidwei.uk>
In-Reply-To: <20241029230521.2385749-2-dw@davidwei.uk>
From: Mina Almasry <almasrymina@google.com>
Date: Fri, 1 Nov 2024 07:57:43 -0700
Message-ID: <CAHS8izOeCDKrEcE4aH=OofTJL0OGtGA5O8R9aKk1=VOb1C9kLQ@mail.gmail.com>
Subject: Re: [PATCH v7 01/15] net: prefix devmem specific helpers
To: David Wei <dw@davidwei.uk>
Cc: io-uring@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jesper Dangaard Brouer <hawk@kernel.org>, David Ahern <dsahern@kernel.org>, 
	Stanislav Fomichev <stfomichev@gmail.com>, Joe Damato <jdamato@fastly.com>, 
	Pedro Tammela <pctammela@mojatatu.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Oct 29, 2024 at 4:06=E2=80=AFPM David Wei <dw@davidwei.uk> wrote:
>
> From: Pavel Begunkov <asml.silence@gmail.com>
>
> Add prefixes to all helpers that are specific to devmem TCP, i.e.
> net_iov_binding[_id].
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: David Wei <dw@davidwei.uk>

Reviewed-by: Mina Almasry <almasrymina@google.com>

