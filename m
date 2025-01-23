Return-Path: <io-uring+bounces-6066-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C0ACA1A5ED
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 15:45:29 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 0E0967A4D34
	for <lists+io-uring@lfdr.de>; Thu, 23 Jan 2025 14:45:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1262E211A2A;
	Thu, 23 Jan 2025 14:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k7RFrWyZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10BF02116EC
	for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 14:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737643508; cv=none; b=egwiNVMYEcYox1+NxwlTVbfPVV9LwYlQJWqPEK3IEbVsrF/evO+LnX2qe3mQgjYFtcsFCYEInKDm5k/uZFJyIvqFo/LTLqc3R6ObwPdyhfefDWsaVcnmuRMg7qx34cpYLb4LEz6zZxnP4I0eZYIRI8k04l2WHUqO/KVGvlvAAIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737643508; c=relaxed/simple;
	bh=He9Z2MlhayQRSMol1OFAUoy+gWZ4/gTKWqBG7ipbAOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KwZkLABEDvxR1YHgm039NfTymhRo6IiloqA2Dd/wJv6Z2Z+oOnyr7Y8tT5TypowBWwe8ZaUBVpu188NdeWJHn0tcIHW/4Q0HOYXpJIrk3gBEs5b9BzbUyPqUVhkikYfpPpq7TH1fdlK4rOnwMLBrNOPyaWmR69f3rU6LOTuIUyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k7RFrWyZ; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-5d3e638e1b4so7646a12.1
        for <io-uring@vger.kernel.org>; Thu, 23 Jan 2025 06:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1737643504; x=1738248304; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=lnhjfXAxLOa1uepSLu1K089T9ufNocJgu0Cy9isqnik=;
        b=k7RFrWyZ8F8Y87GpeC98OQHefy1JsQuw+rRc9K1QY8rQ2ZPpri6qvvGFQ/fYXgPK09
         KtY89pmEoA6RURDw0jh2GIGH2U14oYNdLXOrR0EsNVtvAJpJMNeHol87jpfZPOYM9xqG
         ZrlO5Gk8KkXORHOXbc5A1Blc8vXgldmD5hNWX5Q5Hq1YuG7vrETdfkxeqVlp55wZ6F/L
         SyiTcdZtPT8ntanVC9yjosP5vGDJ6tMC578vQrDIK9QGpVJjMugEevhSO7BZhkC3ruga
         pJthdrGIh85d7VXkoMaxXRgNayAPcq0XeG8wfJGjgWBRglR6R3+kZan+L6e6HKqFtXJh
         kUKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737643504; x=1738248304;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lnhjfXAxLOa1uepSLu1K089T9ufNocJgu0Cy9isqnik=;
        b=YD5QpWsegXSLrNI3oRjIUIk1MxDdcpvUKHXdGdGJXc0sgAxy+3heZYXixga0mn/4XU
         GSnjyqsL6lRaWYAdTT8bwN06fGLrSjkCaX8JvfRjaOXDcPx7LBqSRHiZ4mzV9jbh5WMT
         Y6iP25qG3pawFm9PXRj7DcbbmaqsFfj1EddnYVyzGWFmoHQpBrZklfrb5UmxOk/DBRcw
         2ECojmRFShinwheCcOPGLFojuQiL9BRgFxQf2SxlriCjpK1VNE4VXZAZruaWgpr1DFX6
         qo2wnKJv4dZB6MjDFgmhm7EA3uyemkmO4rY6p6ZDAoZDcDiwwNYs3s7NICy9JtBnypOm
         q3bg==
X-Forwarded-Encrypted: i=1; AJvYcCWG71V60s6ZqW+Az4dWNJqAjQzA6wjuYnern6v4SqeyZ3ZKdwTd1xVZSvcNSTbVk59JUIC1fLl+lw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyHrhC4098PIX1+ENDxXVml3z9NltE+LOSbcNwls77i7eVdnAD3
	u5AuZ/ExShiu0xaQN1vAAWNhlDgekrmcqzF+ol/11SnsBkE9gSJq3ZsLE2Z6VAEEj8kUOizxIAm
	PRURlqqtBU9X5esZCPmVuBVPfjC9ZH/DhIz8V
X-Gm-Gg: ASbGncuXNcPb9ZuTq2Fsr+Ll2hcy5P+ZwhDrXglrFCXnGD5qxzYrojh1zm5JJGvqMXX
	d5I9s3KPauiqAElNVH1v5zQGsqUdEZ/vi8DcD2KrM+mBNgZ8FdBwHLzDa81UlVnlUiFmN/0rzuz
	NExZd9VO5+iJK2Qg==
X-Google-Smtp-Source: AGHT+IFSnnBTbiEoHzZEKNDheO6704AW1EkySA/3YnG/D7TtITBXsx5dFVMCyoiwmrttyh5CyxlCWZ7c5Rbu9FwdXVY=
X-Received: by 2002:a50:ab4a:0:b0:5d0:b20c:205c with SMTP id
 4fb4d7f45d1cf-5dc0c9ed120mr83221a12.5.1737643503863; Thu, 23 Jan 2025
 06:45:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250121-uring-sockcmd-fix-v1-1-add742802a29@google.com>
 <173757472950.267317.14676213787840454554.b4-ty@kernel.dk> <4bf7e5d1-4e66-496d-a503-5dc349efe398@kernel.dk>
In-Reply-To: <4bf7e5d1-4e66-496d-a503-5dc349efe398@kernel.dk>
From: Jann Horn <jannh@google.com>
Date: Thu, 23 Jan 2025 15:44:26 +0100
X-Gm-Features: AWEUYZnVl_DUf1GFwd4nIbztjOneB6732JzFr03eS7HzQFCvWr9ElGOQg0Tal4g
Message-ID: <CAG48ez0r4_U-9TfZOnZA0TKKPc64eYgYQt-3jHDYEqE9OuhLxQ@mail.gmail.com>
Subject: Re: [PATCH] io_uring/uring_cmd: add missing READ_ONCE() on shared
 memory read
To: Jens Axboe <axboe@kernel.dk>
Cc: Pavel Begunkov <asml.silence@gmail.com>, io-uring@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Content-Type: multipart/mixed; boundary="000000000000cc6681062c60a70d"

--000000000000cc6681062c60a70d
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 23, 2025 at 1:18=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote:
> On 1/22/25 12:38 PM, Jens Axboe wrote:
> >
> > On Tue, 21 Jan 2025 17:09:59 +0100, Jann Horn wrote:
> >> cmd->sqe seems to point to shared memory here; so values should only b=
e
> >> read from it with READ_ONCE(). To ensure that the compiler won't gener=
ate
> >> code that assumes the value in memory will stay constant, add a
> >> READ_ONCE().
> >> The callees io_uring_cmd_getsockopt() and io_uring_cmd_setsockopt() al=
ready
> >> do this correctly.
> >>
> >> [...]
> >
> > Applied, thanks!
> >
> > [1/1] io_uring/uring_cmd: add missing READ_ONCE() on shared memory read
> >       commit: 0963dba3dc006b454c54fd019bbbdb931e7a7c70
>
> I took a closer look and this isn't necessary. Either ->sqe is a full
> copy at this point. Should probably be renamed as such... If we want to
> make this clearer, then we should do:

Are you sure? On mainline (at commit 21266b8df522), I applied the
attached diff that basically adds some printf debugging and adds this
in io_uring_cmd_sock():

pr_warn("%s: [first read] cmd->sqe->cmd_op =3D 0x%x\n", __func__,
READ_ONCE(cmd->sqe->cmd_op));
mdelay(2000);
pr_warn("%s: [second read] cmd->sqe->cmd_op =3D 0x%x\n", __func__,
READ_ONCE(cmd->sqe->cmd_op));

Then I ran the attached testcase, which submits a SQE and then
modifies the ->cmd_op of the SQE while it is being submitted.

Resulting dmesg output, showing that cmd->sqe->cmd_op changes when
userspace modifies the SQE:

[  180.415944][ T1110] io_submit_sqes: SQE =3D ffff888010bcc000
[  180.418731][ T1110] io_submit_sqe: SQE =3D ffff888010bcc000
[  180.421191][ T1110] io_queue_sqe
[  180.422160][ T1110] io_issue_sqe
[  180.423101][ T1110] io_uring_cmd: SQE =3D ffff888010bcc000
[  180.424570][ T1110] io_uring_cmd_sock: cmd->sqe =3D ffff888010bcc000
[  180.426272][ T1110] io_uring_cmd_sock: [first read] cmd->sqe->cmd_op =3D=
 0x1234
[  182.429036][ T1110] io_uring_cmd_sock: [second read]
cmd->sqe->cmd_op =3D 0x5678

--000000000000cc6681062c60a70d
Content-Type: text/x-csrc; charset="US-ASCII"; name="uring-cmd-test.c"
Content-Disposition: attachment; filename="uring-cmd-test.c"
Content-Transfer-Encoding: base64
Content-ID: <f_m69g08al0>
X-Attachment-Id: f_m69g08al0

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8cHRocmVhZC5oPgojaW5jbHVkZSA8ZXJyLmg+
CiNpbmNsdWRlIDxzdGRhcmcuaD4KI2luY2x1ZGUgPHN0ZGlvLmg+CiNpbmNsdWRlIDxzdGRsaWIu
aD4KI2luY2x1ZGUgPHBvbGwuaD4KI2luY2x1ZGUgPHVuaXN0ZC5oPgojaW5jbHVkZSA8c3lzL21t
YW4uaD4KI2luY2x1ZGUgPHN5cy9wcmN0bC5oPgojaW5jbHVkZSA8c3lzL2V2ZW50ZmQuaD4KI2lu
Y2x1ZGUgPHN5cy9zeXNjYWxsLmg+CiNpbmNsdWRlIDxzeXMvc29ja2V0Lmg+CiNpbmNsdWRlIDxu
ZXRpbmV0L2luLmg+CiNpbmNsdWRlIDxuZXRpbmV0L3RjcC5oPgojaW5jbHVkZSA8bGludXgvaW9f
dXJpbmcuaD4KCiNkZWZpbmUgU1lTQ0hLKHgpICh7ICAgICAgICAgIFwKICB0eXBlb2YoeCkgX19y
ZXMgPSAoeCk7ICAgICAgXAogIGlmIChfX3JlcyA9PSAodHlwZW9mKHgpKS0xKSBcCiAgICBlcnIo
MSwgIlNZU0NISygiICN4ICIpIik7IFwKICBfX3JlczsgICAgICAgICAgICAgICAgICAgICAgXAp9
KQoKI2RlZmluZSBOVU1fU1FfUEFHRVMgNAoKc3RhdGljIGludCB1cmluZ19mZDsKc3RhdGljIHN0
cnVjdCBpb191cmluZ19zcWUgKnNxX2RhdGE7CgpzdGF0aWMgdm9pZCAqdGhyZWFkX2ZuKHZvaWQg
KmR1bW15KSB7CiAgc2xlZXAoMSk7CiAgc3FfZGF0YS0+Y21kX29wID0gMHg1Njc4OwogIHJldHVy
biBOVUxMOwp9CgppbnQgbWFpbih2b2lkKSB7CiAgcHJpbnRmKCJtYWluIHBpZDogJWRcbiIsIGdl
dHBpZCgpKTsKCiAgLy8gc3EKICBzcV9kYXRhID0gU1lTQ0hLKG1tYXAoTlVMTCwgTlVNX1NRX1BB
R0VTKjB4MTAwMCwgUFJPVF9SRUFEfFBST1RfV1JJVEUsIE1BUF9TSEFSRUR8TUFQX0FOT05ZTU9V
UywgLTEsIDApKTsKICAvLyBjcQogIHZvaWQgKmNxX2RhdGEgPSBTWVNDSEsobW1hcChOVUxMLCBO
VU1fU1FfUEFHRVMqMHgxMDAwLCBQUk9UX1JFQUR8UFJPVF9XUklURSwgTUFQX1NIQVJFRHxNQVBf
QU5PTllNT1VTLCAtMSwgMCkpOwogICoodm9sYXRpbGUgdW5zaWduZWQgaW50ICopKGNxX2RhdGEr
NCkgPSA2NCAqIE5VTV9TUV9QQUdFUzsKCiAgLy8gaW5pdGlhbGl6ZSB1cmluZwogIHN0cnVjdCBp
b191cmluZ19wYXJhbXMgcGFyYW1zID0gewogICAgLmZsYWdzID0gSU9SSU5HX1NFVFVQX0RFRkVS
X1RBU0tSVU58SU9SSU5HX1NFVFVQX1NJTkdMRV9JU1NVRVJ8SU9SSU5HX1NFVFVQX05PX01NQVB8
SU9SSU5HX1NFVFVQX05PX1NRQVJSQVksCiAgICAuc3Ffb2ZmID0geyAudXNlcl9hZGRyID0gKHVu
c2lnbmVkIGxvbmcpc3FfZGF0YSB9LAogICAgLmNxX29mZiA9IHsgLnVzZXJfYWRkciA9ICh1bnNp
Z25lZCBsb25nKWNxX2RhdGEgfQogIH07CiAgdXJpbmdfZmQgPSBTWVNDSEsoc3lzY2FsbChfX05S
X2lvX3VyaW5nX3NldHVwLCAvKmVudHJpZXM9Ki8xMCwgJnBhcmFtcykpOwoKICBpbnQgc29ja2Zk
ID0gU1lTQ0hLKHNvY2tldChBRl9JTkVULCBTT0NLX1NUUkVBTSwgMCkpOwoKICBzcV9kYXRhWzBd
ID0gKHN0cnVjdCBpb191cmluZ19zcWUpIHsKICAgIC5vcGNvZGUgPSBJT1JJTkdfT1BfVVJJTkdf
Q01ELAogICAgLmZsYWdzID0gMCwKICAgIC5pb3ByaW8gPSAwLAogICAgLmZkID0gc29ja2ZkLAog
ICAgLmNtZF9vcCA9IDB4MTIzNCwKICAgIC51c2VyX2RhdGEgPSAxMjMKICB9OwoKICBwdGhyZWFk
X3QgdGhyZWFkOwogIGlmIChwdGhyZWFkX2NyZWF0ZSgmdGhyZWFkLCBOVUxMLCB0aHJlYWRfZm4s
IE5VTEwpKQogICAgZXJyeCgxLCAicHRocmVhZF9jcmVhdGUiKTsKCiAgaW50IHN1Ym1pdHRlZCA9
IFNZU0NISyhzeXNjYWxsKF9fTlJfaW9fdXJpbmdfZW50ZXIsIHVyaW5nX2ZkLAogICAgICAgICAg
ICAgICAgICAgICAgICAgICAgICAgICAvKnRvX3N1Ym1pdD0qLzEsIC8qbWluX2NvbXBsZXRlPSov
MSwKICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgICAgLypmbGFncz0qL0lPUklOR19FTlRF
Ul9HRVRFVkVOVFMsIC8qc2lnPSovTlVMTCwgLypzaWdzej0qLzApKTsKICBwcmludGYoInN1Ym1p
dHRlZCAlZFxuIiwgc3VibWl0dGVkKTsKICByZXR1cm4gMDsKfQo=
--000000000000cc6681062c60a70d
Content-Type: text/x-patch; charset="US-ASCII"; name="uring-cmd-test.diff"
Content-Disposition: attachment; filename="uring-cmd-test.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_m69g0rxq1>
X-Attachment-Id: f_m69g0rxq1

ZGlmZiAtLWdpdCBhL2lvX3VyaW5nL2lvX3VyaW5nLmMgYi9pb191cmluZy9pb191cmluZy5jCmlu
ZGV4IDdiZmJjN2MyMjM2Ny4uMGFlODMwZmFmMGQ5IDEwMDY0NAotLS0gYS9pb191cmluZy9pb191
cmluZy5jCisrKyBiL2lvX3VyaW5nL2lvX3VyaW5nLmMKQEAgLTE3MjMsNiArMTcyMyw4IEBAIHN0
YXRpYyBpbnQgaW9faXNzdWVfc3FlKHN0cnVjdCBpb19raW9jYiAqcmVxLCB1bnNpZ25lZCBpbnQg
aXNzdWVfZmxhZ3MpCiAJY29uc3Qgc3RydWN0IGNyZWQgKmNyZWRzID0gTlVMTDsKIAlpbnQgcmV0
OwogCisJcHJfd2FybigiJXNcbiIsIF9fZnVuY19fKTsKKwogCWlmICh1bmxpa2VseSghaW9fYXNz
aWduX2ZpbGUocmVxLCBkZWYsIGlzc3VlX2ZsYWdzKSkpCiAJCXJldHVybiAtRUJBREY7CiAKQEAg
LTE5NDIsNiArMTk0NCw4IEBAIHN0YXRpYyBpbmxpbmUgdm9pZCBpb19xdWV1ZV9zcWUoc3RydWN0
IGlvX2tpb2NiICpyZXEpCiB7CiAJaW50IHJldDsKIAorCXByX3dhcm4oIiVzXG4iLCBfX2Z1bmNf
Xyk7CisKIAlyZXQgPSBpb19pc3N1ZV9zcWUocmVxLCBJT19VUklOR19GX05PTkJMT0NLfElPX1VS
SU5HX0ZfQ09NUExFVEVfREVGRVIpOwogCiAJLyoKQEAgLTIxNTksNiArMjE2Myw4IEBAIHN0YXRp
YyBpbmxpbmUgaW50IGlvX3N1Ym1pdF9zcWUoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIHN0cnVj
dCBpb19raW9jYiAqcmVxLAogCXN0cnVjdCBpb19zdWJtaXRfbGluayAqbGluayA9ICZjdHgtPnN1
Ym1pdF9zdGF0ZS5saW5rOwogCWludCByZXQ7CiAKKwlwcl93YXJuKCIlczogU1FFID0gJXB4XG4i
LCBfX2Z1bmNfXywgc3FlKTsKKwogCXJldCA9IGlvX2luaXRfcmVxKGN0eCwgcmVxLCBzcWUpOwog
CWlmICh1bmxpa2VseShyZXQpKQogCQlyZXR1cm4gaW9fc3VibWl0X2ZhaWxfaW5pdChzcWUsIHJl
cSwgcmV0KTsKQEAgLTIxODcsNiArMjE5Myw3IEBAIHN0YXRpYyBpbmxpbmUgaW50IGlvX3N1Ym1p
dF9zcWUoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIHN0cnVjdCBpb19raW9jYiAqcmVxLAogCiAJ
fSBlbHNlIGlmICh1bmxpa2VseShyZXEtPmZsYWdzICYgKElPX1JFUV9MSU5LX0ZMQUdTIHwKIAkJ
CQkJICBSRVFfRl9GT1JDRV9BU1lOQyB8IFJFUV9GX0ZBSUwpKSkgeworCQlwcl93YXJuKCIlczog
bm90IHF1ZXVpbmcgU1FFICVweCwgZmxhZ3M9MHglbGx4XG4iLCBfX2Z1bmNfXywgc3FlLCByZXEt
PmZsYWdzKTsKIAkJaWYgKHJlcS0+ZmxhZ3MgJiBJT19SRVFfTElOS19GTEFHUykgewogCQkJbGlu
ay0+aGVhZCA9IHJlcTsKIAkJCWxpbmstPmxhc3QgPSByZXE7CkBAIC0yMzA5LDYgKzIzMTYsNyBA
QCBpbnQgaW9fc3VibWl0X3NxZXMoc3RydWN0IGlvX3JpbmdfY3R4ICpjdHgsIHVuc2lnbmVkIGlu
dCBucikKIAkJCWlvX3JlcV9hZGRfdG9fY2FjaGUocmVxLCBjdHgpOwogCQkJYnJlYWs7CiAJCX0K
KwkJcHJfd2FybigiJXM6IFNRRSA9ICVweFxuIiwgX19mdW5jX18sIHNxZSk7CiAKIAkJLyoKIAkJ
ICogQ29udGludWUgc3VibWl0dGluZyBldmVuIGZvciBzcWUgZmFpbHVyZSBpZiB0aGUKZGlmZiAt
LWdpdCBhL2lvX3VyaW5nL3VyaW5nX2NtZC5jIGIvaW9fdXJpbmcvdXJpbmdfY21kLmMKaW5kZXgg
ZmM5NGM0NjVhOTg1Li41ZDg4YzcyZDZhODkgMTAwNjQ0Ci0tLSBhL2lvX3VyaW5nL3VyaW5nX2Nt
ZC5jCisrKyBiL2lvX3VyaW5nL3VyaW5nX2NtZC5jCkBAIC02LDYgKzYsNyBAQAogI2luY2x1ZGUg
PGxpbnV4L2lvX3VyaW5nL25ldC5oPgogI2luY2x1ZGUgPGxpbnV4L3NlY3VyaXR5Lmg+CiAjaW5j
bHVkZSA8bGludXgvbm9zcGVjLmg+CisjaW5jbHVkZSA8bGludXgvZGVsYXkuaD4KICNpbmNsdWRl
IDxuZXQvc29jay5oPgogCiAjaW5jbHVkZSA8dWFwaS9saW51eC9pb191cmluZy5oPgpAQCAtMjM1
LDYgKzIzNiw4IEBAIGludCBpb191cmluZ19jbWQoc3RydWN0IGlvX2tpb2NiICpyZXEsIHVuc2ln
bmVkIGludCBpc3N1ZV9mbGFncykKIAlzdHJ1Y3QgZmlsZSAqZmlsZSA9IHJlcS0+ZmlsZTsKIAlp
bnQgcmV0OwogCisJcHJfd2FybigiJXM6IFNRRSA9ICVweFxuIiwgX19mdW5jX18sIGlvdWNtZC0+
c3FlKTsKKwogCWlmICghZmlsZS0+Zl9vcC0+dXJpbmdfY21kKQogCQlyZXR1cm4gLUVPUE5PVFNV
UFA7CiAKQEAgLTM0Nyw5ICszNTAsMTUgQEAgaW50IGlvX3VyaW5nX2NtZF9zb2NrKHN0cnVjdCBp
b191cmluZ19jbWQgKmNtZCwgdW5zaWduZWQgaW50IGlzc3VlX2ZsYWdzKQogCXN0cnVjdCBwcm90
byAqcHJvdCA9IFJFQURfT05DRShzay0+c2tfcHJvdCk7CiAJaW50IHJldCwgYXJnID0gMDsKIAor
CXByX3dhcm4oIiVzOiBjbWQtPnNxZSA9ICVweFxuIiwgX19mdW5jX18sIGNtZC0+c3FlKTsKKwog
CWlmICghcHJvdCB8fCAhcHJvdC0+aW9jdGwpCiAJCXJldHVybiAtRU9QTk9UU1VQUDsKIAorCXBy
X3dhcm4oIiVzOiBbZmlyc3QgcmVhZF0gY21kLT5zcWUtPmNtZF9vcCA9IDB4JXhcbiIsIF9fZnVu
Y19fLCBSRUFEX09OQ0UoY21kLT5zcWUtPmNtZF9vcCkpOworCW1kZWxheSgyMDAwKTsKKwlwcl93
YXJuKCIlczogW3NlY29uZCByZWFkXSBjbWQtPnNxZS0+Y21kX29wID0gMHgleFxuIiwgX19mdW5j
X18sIFJFQURfT05DRShjbWQtPnNxZS0+Y21kX29wKSk7CisKIAlzd2l0Y2ggKGNtZC0+c3FlLT5j
bWRfb3ApIHsKIAljYXNlIFNPQ0tFVF9VUklOR19PUF9TSU9DSU5ROgogCQlyZXQgPSBwcm90LT5p
b2N0bChzaywgU0lPQ0lOUSwgJmFyZyk7Cg==
--000000000000cc6681062c60a70d--

