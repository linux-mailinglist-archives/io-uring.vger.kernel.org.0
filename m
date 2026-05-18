Return-Path: <io-uring+bounces-13408-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KL6NO6QyC2oZEgUAu9opvQ
	(envelope-from <io-uring+bounces-13408-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:39:17 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 786AC570210
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 17:39:16 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id DAD0430316E6
	for <lists+io-uring@lfdr.de>; Mon, 18 May 2026 15:35:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DFC13FB7E9;
	Mon, 18 May 2026 15:35:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZdZ+kpIy"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0C6D3F88A8
	for <io-uring@vger.kernel.org>; Mon, 18 May 2026 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779118535; cv=pass; b=tS5MWevgddAzHzkgh3H58PTbd0Uco/y284wZ1Czb2SLOy7u8DJcxdmcRTikiYnFzpaD/uWDV0ctVmWOZol52JHZQp9W84Vqos6/GUGnNv0FdyPgZc2Gg2NkntNeAShg0lZfQlWrFxDedjs4WtpmmyufK+rJvTtZ05Q+nIWthW8s=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779118535; c=relaxed/simple;
	bh=84ThP6pQAX0kQKJdEUw02F6ZsBBCn/2mySdLvp7NIlU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UI9DDT8/lOqYdakWDuB14oVyaMPFfXwLiuNdAn2gZ0nEx+ZbIjX01cEJLXmsxrkMZT4YgE2a+fNV554EtAVxP34UIaKsn+oCkcuvWRbhgkCMe/h4e5A/6H81WtB0dPH47e07JCWspfa5PICBp4+WUnvkWIfgVRbgPJHdGYEI7fQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZdZ+kpIy; arc=pass smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4585a116a4aso1998504f8f.3
        for <io-uring@vger.kernel.org>; Mon, 18 May 2026 08:35:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779118528; cv=none;
        d=google.com; s=arc-20240605;
        b=DMUPwra0/yVb8jxhyAZvL8ek0npVrcGUJO7xv7DxdFwGNd+1CVylKBrNsRy1YwhvgG
         Nm7FcWtZDnv9u238iH+k9hMR2arWIgJdULYKKbuHW7Y+rJULRCKn0kBsPcoFZB8aEh/n
         RVkETTwfiDP5DXEE7jYRCuAUVjJrDMmkv2MYxZD9TXjkGhyYCQENTHEie2eablLIJrYS
         6Mps1eF4y1SzWjSHN/vNarMW7mMf+ZkPrbAWbZzcJ3pkVVdgaIW5oAbspLrdGzXErGRU
         purRqhK36njCtyQZYRp3IiwpPCwyND+iql1P3eQVjrKH4KuifCJUva6OdrQ37eGRPUYD
         X34A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PxUqZGIS6/bcymcwBqDjO10ViTvy5//AhLu9BV3RbqI=;
        fh=SY+B3ubip9xnyqUysmyxB5V/u7ZDfcUJxeBYxmFd6Ew=;
        b=e3n0yJZT6ohAQSsTkIyidZOh6NR2FktOn4lM+CQknOJY3JdAKWhIpZae+a55x20DUU
         2+Hlloa2ob+WkZfuZGGBrbRUBTt/OBWrBtuEivpMSPUXo/xgohIpotfs8JHNaDYNflZQ
         Y7n3R2Vljulb9lahAh719CFEERnMOSlwdhdxbiA0jqDpn0AqQViOvKgpXpOAHeWeLmw0
         iyhVJWmbDNH8pY0zLftd3mb1VKk5vkGnAw4j7kjfYrtr8Ii2QPe2ZVM5dF/bq8kKhkDF
         n0ljI4NGdaddAFkeq+tKuOAENKYn4FYaOWWvHVH1mxQChGbpWTifhqssrhqX5i86E/WI
         8L9w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1779118528; x=1779723328; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PxUqZGIS6/bcymcwBqDjO10ViTvy5//AhLu9BV3RbqI=;
        b=ZdZ+kpIyuvX2VinfqRPp/9cZjjYalunE5oZaVOP+zzyPjgcOXg2S9NCpRXNqBT6FEW
         B/4UyFpUTsQttKh185Bdw4fcU/KY3aOex+wKEitBl7Bk3PRd43vk/tiiS4a+MZfIUKsu
         PlggJprWtA2PkcU6eMeAeMcOdX9etwaac9K+pqxN3RteWJErteGv/c1bSpYz8ifBCfxB
         THTU/a2h+cYUB4hmB0o1KkaBS4JkLck3eoilgIRF9945oRYFx6/RoBXkwmXbLDK7knzz
         ZbWSlYjsebO0835sPUE0u7xztvtr62p7gvSGm/Cn8xwehXoad0PZ9NOuX9/Gey94x76+
         6FSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779118528; x=1779723328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PxUqZGIS6/bcymcwBqDjO10ViTvy5//AhLu9BV3RbqI=;
        b=ifGfgtkxhDCQacp1MY537ZWso6pPOPWCGj6848wXDGkg0DSvDzobP613dsudZB5eum
         uqQ57vUpQ/b2aL0k9SeaeswmqoRdn1iC5OJbvJfQ0dmVDhbzOif4rxJn2P7E5spiDMqM
         CgnC9oLfczF1bu5euP30V5txkGrsSnuvZkHfPd6tDj4gW+0kdtvWF3ZbtaDT80OzdKkH
         NyMrJ0ZQ8k1IINeJMxnuoqj/XKWJAlfwfNTG7FuVoGcDUsmNtKxXTc8P1q8me1PRGv+d
         WhBHnF8p9DHpHE5f+mq4EZXoUQ8IYL1RlnWI2L8m5SrRtpm2FrpYthLssljAYYg8jKwK
         k+XA==
X-Forwarded-Encrypted: i=1; AFNElJ+l9RBSU+jxf24fhFb7FQ3Es3o0pKu96vDf1YxJYjd0pYNscg/KpP2ThtSTCPWXSZH/8Trto9tseA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxMxX0qPb30vxAEAAGMxDAOi7zvexss8GwhyIFJxxTRIMIKw0aH
	zK7iEZ/CpXs/+4VirhISgJtvxksYwnXS308etsLsBxZDzvhyGggr8G6Xqz9gXBCMrdp471T86xr
	O/lloqHKQHxax9zUneM5SmKAGvjMHcaU=
X-Gm-Gg: Acq92OGmpFH5eEXDVItohyVCZr048rkEiPtTl6RS8yNMH2rFkKBASqqGbZoVPP59Byo
	9hh77UQPTLf8IvSOAY1jioMxo0iH3lB85TIUWBrBSH6clvn+kCeqdmrUoCw8m6ES55E5se19Etw
	aJ3zbBgH/6tM+fBIf3sTaJBPt2HDUfImAe88hDvX1/mRJbMnzqH+Ch3rQE7yE83SiO5nF9HidMA
	wf252Ww/vPdu+bIMgvfSnDjlDgUJ8M0R8jHQqHbZAJnxGbK3qJK60FijW2u+to5HoCldzIN5sVA
	u37cIA==
X-Received: by 2002:adf:f1c4:0:b0:45e:73b4:85cc with SMTP id
 ffacd0b85a97d-45e73b48628mr9335860f8f.35.1779118527784; Mon, 18 May 2026
 08:35:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260517-fuse-uaf-patch2@berkoc.com> <2889c98c-21e8-47eb-903a-ea40bf5c8c04@ddn.com>
 <20260518143218.7c7c1689.clarification@berkoc.com> <0e4f0d30-7ed0-431d-ac9a-874b046337cf@bsbernd.com>
In-Reply-To: <0e4f0d30-7ed0-431d-ac9a-874b046337cf@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Mon, 18 May 2026 08:35:16 -0700
X-Gm-Features: AVHnY4KAMmETSI5TPKWYBXHvLjigj-93k6Q8fB0H-L6LEsFNLzxq0oIO4iRR1ls
Message-ID: <CAJnrk1YjShKKKgTox9QQ86Y7zzRWUVscvWRCuetHEqv55bdh6A@mail.gmail.com>
Subject: Re: [PATCH 2/2] fuse: wait for aborted connection before releasing
 last fuse_dev
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Berkant Koc <me@berkoc.com>, Bernd Schubert <bschubert@ddn.com>, 
	Greg KH <gregkh@linuxfoundation.org>, Miklos Szeredi <miklos@szeredi.hu>, security@kernel.org, 
	linux-kernel@vger.kernel.org, io-uring@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	fuse-devel <fuse-devel@lists.linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20251104];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13408-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[berkoc.com,ddn.com,linuxfoundation.org,szeredi.hu,kernel.org,vger.kernel.org,kernel.dk,gmail.com,lists.linux.dev];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FREEMAIL_FROM(0.00)[gmail.com];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	RCPT_COUNT_SEVEN(0.00)[11];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	MISSING_XM_UA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:rdns,tor.lore.kernel.org:helo,mail.gmail.com:mid,bsbernd.com:email,ddn.com:email]
X-Rspamd-Queue-Id: 786AC570210
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, May 18, 2026 at 7:46=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com> =
wrote:
>
>
>
> On 5/18/26 16:32, Berkant Koc wrote:
> > On Mon, 18 May 2026 11:47:00 +0000, Bernd Schubert <bschubert@ddn.com> =
wrote:
> >> Would it be possible for you to test the attached patch?

The fix looks right to me.

Reviewed-by: Joanne Koong <joannelkoong@gmail.com>

> >
> > Reproducer and KASAN harness from the PATCH 2/2 series are staged.
> > Two-arm plan: revert vs apply, race-widening debug hunk kept in both
> > arms, 2x50 iterations each against torvalds/master tip, KASAN + lockdep
> > + kmemleak enabled. Results back within the day once the base resolves.
> >
> > Blocker before I build. The patch references ring->chan and chan->conn.
> > On mainline fs/fuse/dev_uring_i.h declares struct fuse_ring with
> > struct fuse_conn *fc at line 110, no chan member; grep fuse_chan
> > across fs/fuse/ returns zero hits. As-is the patch fails to compile
> > with "struct fuse_ring has no member named chan".
> >
> > Is this based on a DDN topic branch that introduces a fuse_chan
> > abstraction not yet upstream? If so, point me at the base tree or
> > branch URL and I will rebase the test against that. If the references
> > were meant to be ring->fc and fc against current mainline, confirm and
> > I will adjust before the run.

Yes, on mainline the references are meant to be ring->fc, eg

diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
index 5c00fd047c8b..27c417fd9451 100644
--- a/fs/fuse/dev_uring.c
+++ b/fs/fuse/dev_uring.c
@@ -570,6 +570,7 @@ static void fuse_uring_async_stop_queues(struct
work_struct *work)
                                      FUSE_URING_TEARDOWN_INTERVAL);
        } else {
                wake_up_all(&ring->stop_waitq);
+               fuse_conn_put(ring->fc);
        }
 }

@@ -599,6 +600,7 @@ void fuse_uring_stop_queues(struct fuse_ring *ring)

        if (atomic_read(&ring->queue_refs) > 0) {
                ring->teardown_time =3D jiffies;
+               fuse_conn_get(ring->fc);
                INIT_DELAYED_WORK(&ring->async_teardown_work,
                                  fuse_uring_async_stop_queues);
                schedule_delayed_work(&ring->async_teardown_work,

Thanks,
Joanne

> >
> > Assisted-by: Claude:claude-opus-4-7 berkoc-pipeline
> >
>
> Ah, it is based on Miklos' for-next branch, which is also in linux-next
> (I think). Yeah, we have a bit back port headache here.
>
>
> Thanks,
> Bernd

