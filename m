Return-Path: <io-uring+bounces-11953-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QGNHFTcMeWnyugEAu9opvQ
	(envelope-from <io-uring+bounces-11953-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 20:04:23 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id B123599934
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 20:04:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 4074D30CF005
	for <lists+io-uring@lfdr.de>; Tue, 27 Jan 2026 18:53:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E5A329C48;
	Tue, 27 Jan 2026 18:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iZM28Fxj"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9204D32AAD3
	for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 18:53:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769540003; cv=pass; b=fZouVXpNqMbLKUVe7VZrFWew3sOLww78RT+cEr9fGGTv1OdmfZyOwg2eTuw1hwaT3BvUaR4ycoJpXXMCojd+OnxK9up6/XqqpCgJbb+dlKoasf+k5ifLfVe6B3bntc7guaCd284XxadUwLldrZZd/vQum7W6zzHGdhkonB9PCBs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769540003; c=relaxed/simple;
	bh=Za2vWA8pgu6NjnY9Yb4l7dLB/C5iBCIKsmqjk31cA4E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vFohgxLUclS9gB3yM522fouRxhArZnxZ7bDepx6XD3ecATlzeat8jay2bShCVs/DqTI9T3y3E59jm5g7AOZ/WUgR/MIBH6MUGLlUOfLnZUh0OEaXp9FdawxjtVy3o8KFCijUCi8d/99vjZhsx4Y3Y8xgVe5fLJJ1daCFbOd9eKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iZM28Fxj; arc=pass smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-4359a16a400so5404909f8f.1
        for <io-uring@vger.kernel.org>; Tue, 27 Jan 2026 10:53:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769540001; cv=none;
        d=google.com; s=arc-20240605;
        b=FU+U1z/mk0IGYquu6jcMcajDUIYnmY6uhYr3htuuU4tNd1ZHPcdQv55ztsXPSI4Gn1
         9WXJQ5L2b7fFtUpJW0y3u8uivKCAM/s6MMTseKUqyR+0MORLcCyLD+KR+LxMa7h6w2Qz
         cgXduDEAU3EVWtNbFOvElSRs0gSQMJG3/yhbR+hkfLXdIcBrsZ2fGT4UMbJUYwFC5JM5
         Zm6C6Q49dX29k060D9hebfGu3y4O8qGservZbgIy0c+gf91YLluQJ638Vn81xCymoRqv
         KUKyTpkcQpjafvMOJewwg03frzBFH6nFHzipmPQi4WRnrliabGRJ67lNKtDFSYQ7LamO
         okDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+LiXY9JpS/RsbhrhpV/AbZJd4v/MxuL6q0ixFd3r9So=;
        fh=XYp/eX7jR6pjSjAplpsP6Eq/qusT7KS/rrGls9fwNUI=;
        b=QmwuPNzvhvt82OxpKRAyFbY+ZFK2DR/WZWNsmASWh+XpBodp0H4AuhFF+X1n/YhJPm
         i3GhbI09niWpbCp/FdZykLLxi77+IqN2QyqaetF2IRUTuiNWQhWarxvqJQk7OYlA74Tv
         EJSNr7eIslVogzf01YnzrShQqDgCF69c9MBUd9kcGyuoRqV+mqO7G2lyTuj6xTN4lmpQ
         xFpEuoAbxs5PlgXLGJnJDMqST20zmqlqfRxnFDRDgDNgQrMIzi+dxedzPWI1yZ2OqGtL
         hkUaSmu9zOdD+Vtltdo/vQ4e0x8VpvMu0S3NmYmIfap9aE+sUWppAl1qXhBp6HT07jrA
         95Lw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769540001; x=1770144801; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+LiXY9JpS/RsbhrhpV/AbZJd4v/MxuL6q0ixFd3r9So=;
        b=iZM28FxjXFS152P3X19GphiqX74lDpl44s9aGKDTHyHX1So/88zM/OHAOi8SzMA94A
         gfMsVRziDc7eQ4oqO2VT1AURig/e+BTstGTdSDbNJihWF0EblzcVa2slz8C6C25xn3xg
         I1tpi2hJ3D57R/s2kntfZsLvor3hfVJ6PAxPXR6W6JBZuLKEBBIFlMCgJ1ODYmISQ2WP
         JkGlCLndmZj1D0gxIcO4Cc9QFt54jyuMN70bcp+YDyP8rzAq7rB5ri+a8XiCZyTV0k5b
         1KEBaMudcZB+vbx6PrjQ6DByrsyn7RL6ryiaLg2O/wOXqG0meqK4sgYMfMPiYvUbGVG5
         14zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769540001; x=1770144801;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+LiXY9JpS/RsbhrhpV/AbZJd4v/MxuL6q0ixFd3r9So=;
        b=DSUhlCmwim29cqsZwChBITj5pNhnRU2aCNG6d6u+TSnSiOtJvrx90bcGR4Xkn83R9l
         LcMmw508gvJqPmZcLG2ko/DA9eDy2o1YriwFqMhVRDIR8dMjqaOkG+tHbDOJP+xp9tbw
         liQDW2uPfXJBMN+HLFiG2ujriTA7DP8cfYv8impkQ0G8LGWI74/Y89OedxIpWy6wJHL1
         8NA2yUVayFUfi8vAx3tme0jhqHoYuDbdeWoxn0rhGV0lLfDQuqzP6xxEPWgTb4ICjhST
         wOR0Q0RZ8BuETT1nGigQ+JiXg59MVfN6rW/zF2ubgNRIRA1/XOnVw24vo/UzQg5phJc/
         ixcw==
X-Gm-Message-State: AOJu0Yw+iwyiJHLpJpQxhNqntCVkz5LOuabOvU+BccyX0MwiyaDWqBXO
	3752vIpRN1Ythg96cb3KwT+R7h9andQoI0YlchobosaN+CYGms+2kk2/sk4qJd8XN43a1aaJV0K
	dCdz+RtEDNhtrGwSuOTZ5/vN0MbHncX4=
X-Gm-Gg: AZuq6aKrynlUg7p59k+QWo9yFIoZR3tu01LvF7mhj+ugi6pwABYznHM3bJrSJ3lD7BA
	IFVD1rA6hHaX9k9XNc9MEsWxWYBqDF63Gf+hs/biaukC9L1GvdVBv4UmVyg0ccaebtUeom5SWip
	/NrC31lIu0UwNKS1KJIKf/1dce0Z/qcTOQYfvSqf1N8UnY52uwOi3VB4XHszIW7ZOLWu9SCgJUW
	QR7IqdQPDkrp8xi0qKiWNNy2oy7J8lkl/EhD4FXvFrUAgzzs5+AZs8EXu5l9Q/0tX5fsKGnPkty
	ktJQp7B60hxA7rJJDjDPBhxRcJta2duxG4dhM1jdeTIVMFUy61uYvrlSPVwJA9O6P9e6/sepYKo
	cwQblMbyqaO98ywgwiAKFBWyR
X-Received: by 2002:a05:6000:2601:b0:435:dbe3:c6b1 with SMTP id
 ffacd0b85a97d-435dd07fd27mr4324133f8f.25.1769540000650; Tue, 27 Jan 2026
 10:53:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <cover.1769470552.git.asml.silence@gmail.com> <b766b428ec90862d69c9ab843dc89b6d0a017628.1769470552.git.asml.silence@gmail.com>
 <CAADnVQJcoyJ1hmU_oUcjj=8ewPAPTOZ8eccTutSJWHFy2Xza=w@mail.gmail.com> <a61a73b4-01bc-4547-89de-7d70b0c86477@gmail.com>
In-Reply-To: <a61a73b4-01bc-4547-89de-7d70b0c86477@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 27 Jan 2026 10:53:08 -0800
X-Gm-Features: AZwV_QgopQFsBBBwVqRmdEm8ml3k4f5iPW8AsJ0FbSkXCz1em0y6pOFp3cn3QHw
Message-ID: <CAADnVQ+w1OEm7gFb04u6V=5LVw6VefNr_V2FuczBjtaOioH=Cw@mail.gmail.com>
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
	TAGGED_FROM(0.00)[bounces-11953-lists,io-uring=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,mail.gmail.com:mid]
X-Rspamd-Queue-Id: B123599934
X-Rspamd-Action: no action

On Tue, Jan 27, 2026 at 10:42=E2=80=AFAM Pavel Begunkov <asml.silence@gmail=
.com> wrote:
>
> On 1/27/26 17:32, Alexei Starovoitov wrote:
> > On Tue, Jan 27, 2026 at 2:15=E2=80=AFAM Pavel Begunkov <asml.silence@gm=
ail.com> wrote:
> >>
> >> index 000000000000..7a170cb2f388
> >> --- /dev/null
> >> +++ b/tools/testing/selftests/io_uring/types.bpf.h
> >> @@ -0,0 +1,131 @@
> >> +// SPDX-License-Identifier: GPL-2.0 OR BSD-3-Clause
> >> +#include <linux/types.h>
> >> +#include <bpf/bpf_helpers.h>
> >> +
> >> +struct io_ring_ctx {
> >> +};
> >> +
> >> +struct io_uring_sqe {
> >> +       __u8    opcode;         /* type of operation for this sqe */
> >> +       __u8    flags;          /* IOSQE_ flags */
> >> +       __u16   ioprio;         /* ioprio for the request */
> >> +       __s32   fd;             /* file descriptor to do IO on */
> >
> > 1.
> > No need to copy paste. Just include vmlinux.h. It's there.
> >
> > 2.
> > drop KF_TRUSTED_ARGS from kfunc. It's a default now and this flag
> > was removed.
>
> Got it, will change both, thanks
>
> > 3.
> > add a runtime logic to check that the return value is either IOU_LOOP_C=
ONTINUE
> > or IOU_LOOP_STOP or instruct the verifier do it statically.
> > Otherwise it will be less convenient to extend to other commands,
> > since the way I read it IOU_LOOP_CONTINUE =3D=3D 0 aliases to any value=
 > 1.
>
> Is there a struct_ops hook that can help with that? check_return_code()
> has some hard-coded checks, but I can't find anything customizable for
> struct_ops.

yep. check_return_code() is the one and you're correct. It's not
customizable atm. Much simpler to do a runtime check for now and
improve through the verifier support later.

