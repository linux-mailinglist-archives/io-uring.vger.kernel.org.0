Return-Path: <io-uring+bounces-5749-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 99D62A04B85
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 22:25:58 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 374A33A375D
	for <lists+io-uring@lfdr.de>; Tue,  7 Jan 2025 21:25:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AF9B31F3D57;
	Tue,  7 Jan 2025 21:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b="VK3KfPUA"
X-Original-To: io-uring@vger.kernel.org
Received: from fanzine2.igalia.com (fanzine.igalia.com [178.60.130.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 024641802AB;
	Tue,  7 Jan 2025 21:25:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=178.60.130.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736285144; cv=none; b=bt7+oMtcbIIHef4j9riLLuQHT5Yu2ZotyGzoDeW5VbstB4QDbtYRe55rJfwKMe/3kQviOyyd9AIeSAcbgzbBQ5HUUc520vSexq4wYfQhGTCxSfUOIm927EvdJ4AaJTICCNtC1CwToASSgHCl/sULneGt+3d2Wam6J4J+5RaanG0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736285144; c=relaxed/simple;
	bh=P+PimLVh7e648JDmIUGbfLGytAhQSQEnrcfvEDBcMk0=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=r73xP9f8dtgvLsretZdRADgnsAgROqTbgwZluxnPYCmwCDwFjqbOQI40pDb3KBozpnuQZmlOv3M08YiHYO/gNQkxzzkbm74N1OyRVf64Coh+LCwl/jXJlo+FdCkWGUaeQqRrPpuNIimcgBG9LWiMZeMbELJYe2EKlaXFTrmTdUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com; spf=pass smtp.mailfrom=igalia.com; dkim=pass (2048-bit key) header.d=igalia.com header.i=@igalia.com header.b=VK3KfPUA; arc=none smtp.client-ip=178.60.130.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=igalia.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=igalia.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=igalia.com;
	s=20170329; h=Content-Transfer-Encoding:Content-Type:MIME-Version:Message-ID:
	Date:References:In-Reply-To:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=JTCKUwcxMKvB6TGql6lvF71gb3/bGoVmJkkdeontYcI=; b=VK3KfPUAknijjFtWo8wU5nk7fY
	4OXektE5lA2/pvo3MIJpO29x7OIOQ/cAw4c53AbUsAecoQ6m3Pu5Da5ehgVpJ5iP2GnoutMdBm7X8
	UcmQLnsVUfT/Yi1OYQ9ArxVugv6w1CwH7NPq00eWOCei0gVrcq8KpYqgt7l73+q5JgbiRMgqDp+oO
	mdQ09fTJBpoVyvGmdYNL7VkvHJD7yj1QnkeB3DKSRYxTsoV0jxi2XfO+H7RqDi1gRqv16mZ/FZ0xN
	DiRxHKv70Aj265SWPhKg7UFv64n54XYzOiWJNIiFq2r6AzyTUgsG31r8LmZky3SKc8tYLW5mkzcMk
	n7eAEu1Q==;
Received: from bl23-10-177.dsl.telepac.pt ([144.64.10.177] helo=localhost)
	by fanzine2.igalia.com with esmtpsa 
	(Cipher TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256) (Exim)
	id 1tVH4s-00CtLJ-Em; Tue, 07 Jan 2025 22:25:30 +0100
From: Luis Henriques <luis@igalia.com>
To: Bernd Schubert <bernd@bsbernd.com>
Cc: Luis Henriques <luis@igalia.com>,  Bernd Schubert <bschubert@ddn.com>,
  Miklos Szeredi <miklos@szeredi.hu>,  Jens Axboe <axboe@kernel.dk>,  Pavel
 Begunkov <asml.silence@gmail.com>,  linux-fsdevel@vger.kernel.org,
  io-uring@vger.kernel.org,  Joanne Koong <joannelkoong@gmail.com>,  Josef
 Bacik <josef@toxicpanda.com>,  Amir Goldstein <amir73il@gmail.com>,  Ming
 Lei <tom.leiming@gmail.com>,  David Wei <dw@davidwei.uk>
Subject: Re: [PATCH v9 13/17] fuse: Allow to queue fg requests through io-uring
In-Reply-To: <87a9354b-4371-4862-b94c-8797e77b0068@bsbernd.com> (Bernd
	Schubert's message of "Tue, 7 Jan 2025 19:59:06 +0100")
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
	<20250107-fuse-uring-for-6-10-rfc4-v9-13-9c786f9a7a9d@ddn.com>
	<87a5c239ho.fsf@igalia.com>
	<87a9354b-4371-4862-b94c-8797e77b0068@bsbernd.com>
Date: Tue, 07 Jan 2025 21:25:49 +0000
Message-ID: <87zfk28gf6.fsf@igalia.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

On Tue, Jan 07 2025, Bernd Schubert wrote:

> On 1/7/25 16:54, Luis Henriques wrote:
>
> [...]
>
>>> @@ -785,10 +830,22 @@ static void fuse_uring_do_register(struct fuse_ri=
ng_ent *ring_ent,
>>>   				   unsigned int issue_flags)
>>>   {
>>>   	struct fuse_ring_queue *queue =3D ring_ent->queue;
>>> +	struct fuse_ring *ring =3D queue->ring;
>>> +	struct fuse_conn *fc =3D ring->fc;
>>> +	struct fuse_iqueue *fiq =3D &fc->iq;
>>>     	spin_lock(&queue->lock);
>>>   	fuse_uring_ent_avail(ring_ent, queue);
>>>   	spin_unlock(&queue->lock);
>>> +
>>> +	if (!ring->ready) {
>>> +		bool ready =3D is_ring_ready(ring, queue->qid);
>>> +
>>> +		if (ready) {
>>> +			WRITE_ONCE(ring->ready, true);
>>> +			fiq->ops =3D &fuse_io_uring_ops;
>> Shouldn't we be taking the fiq->lock to protect the above operation?
>
> I switched the order and changed it to WRITE_ONCE. fiq->lock would
> require that doing the operations would also hold lock.
> Also see "[PATCH v9 16/17] fuse: block request allocation until",
> there should be no races anyone.

OK, great.  I still need to go read the code a few more times, I guess.
Thank you for your help understanding this code, Bernd.

Cheers,
--=20
Lu=C3=ADs

>>=20
>>> +		}
>>> +	}
>>>   }
>>>     /*
>>> @@ -979,3 +1036,119 @@ int __maybe_unused fuse_uring_cmd(struct io_urin=
g_cmd *cmd,
>>>     	return -EIOCBQUEUED;
>>>   }
>>> +
>>> +/*
>>> + * This prepares and sends the ring request in fuse-uring task context.
>>> + * User buffers are not mapped yet - the application does not have per=
mission
>>> + * to write to it - this has to be executed in ring task context.
>>> + */
>>> +static void
>>> +fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
>>> +			    unsigned int issue_flags)
>>> +{
>>> +	struct fuse_ring_ent *ent =3D uring_cmd_to_ring_ent(cmd);
>>> +	struct fuse_ring_queue *queue =3D ent->queue;
>>> +	int err;
>>> +
>>> +	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD)) {
>>> +		err =3D -ECANCELED;
>>> +		goto terminating;
>>> +	}
>>> +
>>> +	err =3D fuse_uring_prepare_send(ent);
>>> +	if (err)
>>> +		goto err;
>> Suggestion: simplify this function flow.  Something like:
>> 	int err =3D 0;
>> 	if (unlikely(issue_flags & IO_URING_F_TASK_DEAD))
>> 		err =3D -ECANCELED;
>> 	else if (fuse_uring_prepare_send(ent)) {
>> 		fuse_uring_next_fuse_req(ent, queue, issue_flags);
>> 		return;
>> 	}
>> 	spin_lock(&queue->lock);
>>          [...]
>
> That makes it look like fuse_uring_prepare_send is not an
> error, but expected. How about like this?
>
> static void
> fuse_uring_send_req_in_task(struct io_uring_cmd *cmd,
> 			    unsigned int issue_flags)
> {
> 	struct fuse_ring_ent *ent =3D uring_cmd_to_ring_ent(cmd);
> 	struct fuse_ring_queue *queue =3D ent->queue;
> 	int err;
>
> 	if (!(issue_flags & IO_URING_F_TASK_DEAD)) {
> 		err =3D fuse_uring_prepare_send(ent);
> 		if (err) {
> 			fuse_uring_next_fuse_req(ent, queue, issue_flags);
> 			return;
> 		}
> 	} else {
> 		err =3D -ECANCELED;
> 	}
>
> 	spin_lock(&queue->lock);
> 	ent->state =3D FRRS_USERSPACE;
> 	list_move(&ent->list, &queue->ent_in_userspace);
> 	spin_unlock(&queue->lock);
>
> 	io_uring_cmd_done(cmd, err, 0, issue_flags);
> 	ent->cmd =3D NULL;
> }
>
>
>
> Thanks,
> Bernd

