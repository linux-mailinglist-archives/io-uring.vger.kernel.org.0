Return-Path: <io-uring+bounces-6005-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id BA1CBA1649D
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 01:33:28 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 95F067A1DD3
	for <lists+io-uring@lfdr.de>; Mon, 20 Jan 2025 00:33:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7F3BEAD51;
	Mon, 20 Jan 2025 00:33:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="JKoidbvk";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="OSf5yivb"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-a2-smtp.messagingengine.com (fhigh-a2-smtp.messagingengine.com [103.168.172.153])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6290181E;
	Mon, 20 Jan 2025 00:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.153
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737333190; cv=none; b=W+BWnSnWJShovT1h9Ge+wG6uKwVS7YzxzkHn8d8LX1z8dfCP9SA6T+z0YbpqCaao1ZTnCgL/7EaqGXXiUnROws4SpOG9Bo4xKd8f7Ebeji7GSDMn05uLGPDPgjXZI7Q65fU+rtyPlvHQ3smhWZ3/smE2BC2jUZ7yguruGSbOumY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737333190; c=relaxed/simple;
	bh=ZgPkgGEtzWrwAyakbc2rbUxUm9LBVWOO6QEbdtbsyFM=;
	h=Content-Type:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To; b=nkiN2h0gYJeecfDYNlHk0S3s18gah8gf41MkUzIS8UnqEAF80pVHxNP6pXjBFI8OxL63mRV/vitojodonix2qQ3i6KwNqSDXsBCdOWg4CmEYXj0halOJx+75RooIcqFu9UYqFxkBzYqIhorSokff6jLluUvorZEC9dArc82NV1U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=JKoidbvk; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=OSf5yivb; arc=none smtp.client-ip=103.168.172.153
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-03.internal (phl-compute-03.phl.internal [10.202.2.43])
	by mailfhigh.phl.internal (Postfix) with ESMTP id 39C741140191;
	Sun, 19 Jan 2025 19:33:05 -0500 (EST)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Sun, 19 Jan 2025 19:33:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1737333185; x=1737419585; bh=kBpcFu8AAf
	65TquIgbej+EfOo3X4Wlw+Z2FzGW/H85E=; b=JKoidbvkoueOVv4kyqtIAFeSAU
	zOPmP0QkeSuqdC5FHFBnGky7RPVAziGQ2DlRteL4hYNi1oXb62MJZbxcrvfrGhb1
	7kB5L3ECxfqg4G7tg6mrfDSRtC0aVwgV/wdsp1fri6GIlLKT0zxheQgjFsii5V6b
	4Eme8k0e1ZcJWnp+QhkKLEVPVPPwnhXVsD1lAGM9gMO0agRVLeNtfrWMkgure0Uh
	WUDGn4qz0bhyotWNWTKA4lUUE/jwAhavYl7BjVZrxp6FwCDr4E4ZKOla8Okd/OtN
	aiHcVz9PvcCX18ioERdcJTsuoj0LEQKA73GvwEbMGqNdi+mvaRZ/SUFcT7Mw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=
	1737333185; x=1737419585; bh=kBpcFu8AAf65TquIgbej+EfOo3X4Wlw+Z2F
	zGW/H85E=; b=OSf5yivbqVm10DbWhQaOaSjAkPGee/AL2lzRHpGai2EtQZ8EkwK
	AtZDgZ+bbjBvkV2e89w3b2G/iGvAIYS4sMRNbcbWKDN5sUdnuQH31bixGzGXkLvX
	bTri9R2i845mjGwf7qE+QqGV8U0kJxQxPH6apPxgjSgCIxTADuIzAClr9YHAHsix
	j17qkHWYPKnnFAF26hffAY4KAiB31/QtRP1maKeDQ2KvC8ooieZHBB10UZvldiEJ
	x5aOWjVX4pcfsIZUifVIcydq9VFkw2k5sUegG6n0XAT1YbAAs+K4+hlb0kKCNRIj
	fP0piv5E+PUYJ4ZlNjN9xl6McLPbJY5tTFQ==
X-ME-Sender: <xms:wJmNZxxZPqBjpOhQ5EOSQw5499r4iC5EnctufUpu_2qB7Rvf6lyTaw>
    <xme:wJmNZxQ1YfRT__nalzYuDxRGhcmvj8V7c4_JAbFTNTTSJsDccowjFXgdyfZZWI6TD
    RRdC-sor8QQhmQU>
X-ME-Received: <xmr:wJmNZ7Xp46DWoZf12uQU_DyIAgzhD2o-V15CRVNcGI62SeZVv5UKolf7bgZ9vCMuAPislA1I6_Q5O4A5BexMC3KGmxyoF0zhPD0CWgL6dB5RuQ1cqchf>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudeikedgvddvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurheptgfkffggfgfuvfevfhfhjgesmhdtreertddvjeen
    ucfhrhhomhepuegvrhhnugcuufgthhhusggvrhhtuceosggvrhhnugessghssggvrhhnug
    drtghomheqnecuggftrfgrthhtvghrnhepudeftdegteeghfeludejvdeiieekueeiheev
    leefvdekuefhueejtdekkedtvefgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsggvrhhnugessghssggvrhhnugdrtghomhdpnhgspghrtghp
    thhtohepuddupdhmohguvgepshhmthhpohhuthdprhgtphhtthhopehjohgrnhhnvghlkh
    hoohhnghesghhmrghilhdrtghomhdprhgtphhtthhopegsshgthhhusggvrhhtseguughn
    rdgtohhmpdhrtghpthhtohepmhhikhhlohhssehsiigvrhgvughirdhhuhdprhgtphhtth
    hopegrgigsohgvsehkvghrnhgvlhdrughkpdhrtghpthhtoheprghsmhhlrdhsihhlvghn
    tggvsehgmhgrihhlrdgtohhmpdhrtghpthhtoheplhhinhhugidqfhhsuggvvhgvlhesvh
    hgvghrrdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehiohdquhhrihhnghesvhhgvghr
    rdhkvghrnhgvlhdrohhrghdprhgtphhtthhopehjohhsvghfsehtohigihgtphgrnhgurg
    drtghomhdprhgtphhtthhopegrmhhirhejfehilhesghhmrghilhdrtghomh
X-ME-Proxy: <xmx:wJmNZziMwvIZfMui4DRdh8d3UM5cnzIJgogV_0-OoNPZ87bbWHjzQQ>
    <xmx:wJmNZzDIszZMZvKhkyJmWR1uz7GhcT46OCAhHrkvR7UeSbYwdPOBtg>
    <xmx:wJmNZ8L4jX3k7p1CPqliVmwBiORl66h0hwTtn7On2cJ8n-xoWGPYfg>
    <xmx:wJmNZyDIZgSU4y3ADA7pvlNEL-QTzVBlf6YtNQcBjlDMx3RobS-GGA>
    <xmx:wZmNZwLAe7NySyF2BjGkzADbqHfr6Sd_qiAJ0qSPj5cCUadEpup9o8rD>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 19 Jan 2025 19:33:02 -0500 (EST)
Content-Type: multipart/mixed; boundary="------------qh4PRPzea2n8fvqt04svWEYP"
Message-ID: <eafad58d-07ec-4e7f-9482-26f313f066cc@bsbernd.com>
Date: Mon, 20 Jan 2025 01:33:02 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
To: Joanne Koong <joannelkoong@gmail.com>, Bernd Schubert <bschubert@ddn.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Jens Axboe <axboe@kernel.dk>,
 Pavel Begunkov <asml.silence@gmail.com>, linux-fsdevel@vger.kernel.org,
 io-uring@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>,
 Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>,
 David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
 <CAJnrk1afYmo+GNRb=OF7CUQzY5ocEus0h=93ax8usA9oa_qM4Q@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1afYmo+GNRb=OF7CUQzY5ocEus0h=93ax8usA9oa_qM4Q@mail.gmail.com>

This is a multi-part message in MIME format.
--------------qh4PRPzea2n8fvqt04svWEYP
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi Joanne,

sorry for my late reply, I was occupied all week. 

On 1/13/25 23:44, Joanne Koong wrote:
> On Mon, Jan 6, 2025 at 4:25 PM Bernd Schubert <bschubert@ddn.com> wrote:
>>
>> This adds support for fuse request completion through ring SQEs
>> (FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
>> the ring entry it becomes available for new fuse requests.
>> Handling of requests through the ring (SQE/CQE handling)
>> is complete now.
>>
>> Fuse request data are copied through the mmaped ring buffer,
>> there is no support for any zero copy yet.
>>
>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>> ---
>>  fs/fuse/dev_uring.c   | 450 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>  fs/fuse/dev_uring_i.h |  12 ++
>>  fs/fuse/fuse_i.h      |   4 +
>>  3 files changed, 466 insertions(+)
>>
>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>> index b44ba4033615e01041313c040035b6da6af0ee17..f44e66a7ea577390da87e9ac7d118a9416898c28 100644
>> --- a/fs/fuse/dev_uring.c
>> +++ b/fs/fuse/dev_uring.c
>> @@ -26,6 +26,19 @@ bool fuse_uring_enabled(void)
>>         return enable_uring;
>>  }
>>
>> +static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
>> +                              int error)
>> +{
>> +       struct fuse_req *req = ring_ent->fuse_req;
>> +
>> +       if (set_err)
>> +               req->out.h.error = error;
> 
> I think we could get away with not having the "bool set_err" as an
> argument if we do "if (error)" directly. AFAICT, we can use the value
> of error directly since  it always returns zero on success and any
> non-zero value is considered an error.

I had done this because of fuse_uring_commit()


	err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
	if (err) {
		/* req->out.h.error already set */
		goto out;
	}


In fuse_uring_out_header_has_err() the header might already have the
error code, but there are other errors as well. Well, setting an 
existing error code saves us a few lines and conditions, so you are
probably right and I removed that argument now.


> 
>> +
>> +       clear_bit(FR_SENT, &req->flags);
>> +       fuse_request_end(ring_ent->fuse_req);
>> +       ring_ent->fuse_req = NULL;
>> +}
>> +
>>  void fuse_uring_destruct(struct fuse_conn *fc)
>>  {
>>         struct fuse_ring *ring = fc->ring;
>> @@ -41,8 +54,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
>>                         continue;
>>
>>                 WARN_ON(!list_empty(&queue->ent_avail_queue));
>> +               WARN_ON(!list_empty(&queue->ent_w_req_queue));
>>                 WARN_ON(!list_empty(&queue->ent_commit_queue));
>> +               WARN_ON(!list_empty(&queue->ent_in_userspace));
>>
>> +               kfree(queue->fpq.processing);
>>                 kfree(queue);
>>                 ring->queues[qid] = NULL;
>>         }
>> @@ -101,20 +117,34 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>>  {
>>         struct fuse_conn *fc = ring->fc;
>>         struct fuse_ring_queue *queue;
>> +       struct list_head *pq;
>>
>>         queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
>>         if (!queue)
>>                 return NULL;
>> +       pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
>> +       if (!pq) {
>> +               kfree(queue);
>> +               return NULL;
>> +       }
>> +
>>         queue->qid = qid;
>>         queue->ring = ring;
>>         spin_lock_init(&queue->lock);
>>
>>         INIT_LIST_HEAD(&queue->ent_avail_queue);
>>         INIT_LIST_HEAD(&queue->ent_commit_queue);
>> +       INIT_LIST_HEAD(&queue->ent_w_req_queue);
>> +       INIT_LIST_HEAD(&queue->ent_in_userspace);
>> +       INIT_LIST_HEAD(&queue->fuse_req_queue);
>> +
>> +       queue->fpq.processing = pq;
>> +       fuse_pqueue_init(&queue->fpq);
>>
>>         spin_lock(&fc->lock);
>>         if (ring->queues[qid]) {
>>                 spin_unlock(&fc->lock);
>> +               kfree(queue->fpq.processing);
>>                 kfree(queue);
>>                 return ring->queues[qid];
>>         }
>> @@ -128,6 +158,214 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>>         return queue;
>>  }
>>
>> +/*
>> + * Checks for errors and stores it into the request
>> + */
>> +static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
>> +                                        struct fuse_req *req,
>> +                                        struct fuse_conn *fc)
>> +{
>> +       int err;
>> +
>> +       err = -EINVAL;
>> +       if (oh->unique == 0) {
>> +               /* Not supportd through io-uring yet */
>> +               pr_warn_once("notify through fuse-io-uring not supported\n");
>> +               goto seterr;
>> +       }
>> +
>> +       err = -EINVAL;
>> +       if (oh->error <= -ERESTARTSYS || oh->error > 0)
>> +               goto seterr;
>> +
>> +       if (oh->error) {
>> +               err = oh->error;
>> +               goto err;
>> +       }
>> +
>> +       err = -ENOENT;
>> +       if ((oh->unique & ~FUSE_INT_REQ_BIT) != req->in.h.unique) {
>> +               pr_warn_ratelimited("unique mismatch, expected: %llu got %llu\n",
>> +                                   req->in.h.unique,
>> +                                   oh->unique & ~FUSE_INT_REQ_BIT);
>> +               goto seterr;
>> +       }
>> +
>> +       /*
>> +        * Is it an interrupt reply ID?
>> +        * XXX: Not supported through fuse-io-uring yet, it should not even
>> +        *      find the request - should not happen.
>> +        */
>> +       WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
>> +
>> +       return 0;
>> +
>> +seterr:
>> +       oh->error = err;
>> +err:
>> +       return err;
>> +}
>> +
>> +static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
>> +                                    struct fuse_req *req,
>> +                                    struct fuse_ring_ent *ent)
>> +{
>> +       struct fuse_copy_state cs;
>> +       struct fuse_args *args = req->args;
>> +       struct iov_iter iter;
>> +       int err, res;
>> +       struct fuse_uring_ent_in_out ring_in_out;
>> +
>> +       res = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
>> +                            sizeof(ring_in_out));
>> +       if (res)
>> +               return -EFAULT;
>> +
>> +       err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
>> +                         &iter);
>> +       if (err)
>> +               return err;
>> +
>> +       fuse_copy_init(&cs, 0, &iter);
>> +       cs.is_uring = 1;
>> +       cs.req = req;
>> +
>> +       return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
>> +}
>> +
>> + /*
>> +  * Copy data from the req to the ring buffer
>> +  */
>> +static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
>> +                                  struct fuse_ring_ent *ent)
>> +{
>> +       struct fuse_copy_state cs;
>> +       struct fuse_args *args = req->args;
>> +       struct fuse_in_arg *in_args = args->in_args;
>> +       int num_args = args->in_numargs;
>> +       int err, res;
>> +       struct iov_iter iter;
>> +       struct fuse_uring_ent_in_out ent_in_out = {
>> +               .flags = 0,
>> +               .commit_id = ent->commit_id,
>> +       };
>> +
>> +       if (WARN_ON(ent_in_out.commit_id == 0))
>> +               return -EINVAL;
>> +
>> +       err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
>> +       if (err) {
>> +               pr_info_ratelimited("fuse: Import of user buffer failed\n");
>> +               return err;
>> +       }
>> +
>> +       fuse_copy_init(&cs, 1, &iter);
>> +       cs.is_uring = 1;
>> +       cs.req = req;
>> +
>> +       if (num_args > 0) {
>> +               /*
>> +                * Expectation is that the first argument is the per op header.
>> +                * Some op code have that as zero.
>> +                */
>> +               if (args->in_args[0].size > 0) {
>> +                       res = copy_to_user(&ent->headers->op_in, in_args->value,
>> +                                          in_args->size);
>> +                       err = res > 0 ? -EFAULT : res;
>> +                       if (err) {
>> +                               pr_info_ratelimited(
>> +                                       "Copying the header failed.\n");
>> +                               return err;
>> +                       }
>> +               }
>> +               in_args++;
>> +               num_args--;
>> +       }
>> +
>> +       /* copy the payload */
>> +       err = fuse_copy_args(&cs, num_args, args->in_pages,
>> +                            (struct fuse_arg *)in_args, 0);
>> +       if (err) {
>> +               pr_info_ratelimited("%s fuse_copy_args failed\n", __func__);
>> +               return err;
>> +       }
>> +
>> +       ent_in_out.payload_sz = cs.ring.copied_sz;
>> +       res = copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
>> +                          sizeof(ent_in_out));
>> +       err = res > 0 ? -EFAULT : res;
>> +       if (err)
>> +               return err;
>> +
>> +       return 0;
>> +}
>> +
>> +static int
>> +fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
>> +{
>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>> +       struct fuse_ring *ring = queue->ring;
>> +       struct fuse_req *req = ring_ent->fuse_req;
>> +       int err, res;
>> +
>> +       err = -EIO;
>> +       if (WARN_ON(ring_ent->state != FRRS_FUSE_REQ)) {
>> +               pr_err("qid=%d ring-req=%p invalid state %d on send\n",
>> +                      queue->qid, ring_ent, ring_ent->state);
>> +               err = -EIO;
>> +               goto err;
>> +       }
>> +
>> +       /* copy the request */
>> +       err = fuse_uring_copy_to_ring(ring, req, ring_ent);
>> +       if (unlikely(err)) {
>> +               pr_info_ratelimited("Copy to ring failed: %d\n", err);
>> +               goto err;
>> +       }
>> +
>> +       /* copy fuse_in_header */
>> +       res = copy_to_user(&ring_ent->headers->in_out, &req->in.h,
>> +                          sizeof(req->in.h));
>> +       err = res > 0 ? -EFAULT : res;
>> +       if (err)
>> +               goto err;
>> +
>> +       set_bit(FR_SENT, &req->flags);
>> +       return 0;
>> +
>> +err:
>> +       fuse_uring_req_end(ring_ent, true, err);
>> +       return err;
>> +}
>> +
>> +/*
>> + * Write data to the ring buffer and send the request to userspace,
>> + * userspace will read it
>> + * This is comparable with classical read(/dev/fuse)
>> + */
>> +static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent,
>> +                                       unsigned int issue_flags)
>> +{
>> +       int err = 0;
>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>> +
>> +       err = fuse_uring_prepare_send(ring_ent);
>> +       if (err)
>> +               goto err;
>> +
>> +       spin_lock(&queue->lock);
>> +       ring_ent->state = FRRS_USERSPACE;
>> +       list_move(&ring_ent->list, &queue->ent_in_userspace);
>> +       spin_unlock(&queue->lock);
>> +
>> +       io_uring_cmd_done(ring_ent->cmd, 0, 0, issue_flags);
>> +       ring_ent->cmd = NULL;
>> +       return 0;
>> +
>> +err:
>> +       return err;
>> +}
>> +
>>  /*
>>   * Make a ring entry available for fuse_req assignment
>>   */
>> @@ -138,6 +376,210 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
>>         ring_ent->state = FRRS_AVAILABLE;
>>  }
>>
>> +/* Used to find the request on SQE commit */
>> +static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent,
>> +                                struct fuse_req *req)
>> +{
>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>> +       struct fuse_pqueue *fpq = &queue->fpq;
>> +       unsigned int hash;
>> +
>> +       /* commit_id is the unique id of the request */
>> +       ring_ent->commit_id = req->in.h.unique;
>> +
>> +       req->ring_entry = ring_ent;
>> +       hash = fuse_req_hash(ring_ent->commit_id);
>> +       list_move_tail(&req->list, &fpq->processing[hash]);
>> +}
>> +
>> +/*
>> + * Assign a fuse queue entry to the given entry
>> + */
>> +static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ring_ent,
>> +                                          struct fuse_req *req)
>> +{
>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>> +
>> +       lockdep_assert_held(&queue->lock);
>> +
>> +       if (WARN_ON_ONCE(ring_ent->state != FRRS_AVAILABLE &&
>> +                        ring_ent->state != FRRS_COMMIT)) {
>> +               pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
>> +                       ring_ent->state);
>> +       }
>> +       list_del_init(&req->list);
>> +       clear_bit(FR_PENDING, &req->flags);
>> +       ring_ent->fuse_req = req;
>> +       ring_ent->state = FRRS_FUSE_REQ;
>> +       list_move(&ring_ent->list, &queue->ent_w_req_queue);
>> +       fuse_uring_add_to_pq(ring_ent, req);
>> +}
>> +
>> +/*
>> + * Release the ring entry and fetch the next fuse request if available
>> + *
>> + * @return true if a new request has been fetched
>> + */
>> +static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ring_ent)
>> +       __must_hold(&queue->lock)
>> +{
>> +       struct fuse_req *req;
>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>> +       struct list_head *req_queue = &queue->fuse_req_queue;
>> +
>> +       lockdep_assert_held(&queue->lock);
>> +
>> +       /* get and assign the next entry while it is still holding the lock */
>> +       req = list_first_entry_or_null(req_queue, struct fuse_req, list);
>> +       if (req) {
>> +               fuse_uring_add_req_to_ring_ent(ring_ent, req);
>> +               return true;
>> +       }
>> +
>> +       return false;
>> +}
>> +
>> +/*
>> + * Read data from the ring buffer, which user space has written to
>> + * This is comparible with handling of classical write(/dev/fuse).
>> + * Also make the ring request available again for new fuse requests.
>> + */
>> +static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
>> +                             unsigned int issue_flags)
>> +{
>> +       struct fuse_ring *ring = ring_ent->queue->ring;
>> +       struct fuse_conn *fc = ring->fc;
>> +       struct fuse_req *req = ring_ent->fuse_req;
>> +       ssize_t err = 0;
>> +       bool set_err = false;
>> +
>> +       err = copy_from_user(&req->out.h, &ring_ent->headers->in_out,
>> +                            sizeof(req->out.h));
>> +       if (err) {
>> +               req->out.h.error = err;
>> +               goto out;
>> +       }
>> +
>> +       err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
>> +       if (err) {
>> +               /* req->out.h.error already set */
>> +               goto out;
>> +       }
>> +
>> +       err = fuse_uring_copy_from_ring(ring, req, ring_ent);
>> +       if (err)
>> +               set_err = true;
>> +
>> +out:
>> +       fuse_uring_req_end(ring_ent, set_err, err);
>> +}
>> +
>> +/*
>> + * Get the next fuse req and send it
>> + */
>> +static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
>> +                                    struct fuse_ring_queue *queue,
>> +                                    unsigned int issue_flags)
>> +{
>> +       int err;
>> +       bool has_next;
>> +
>> +retry:
>> +       spin_lock(&queue->lock);
>> +       fuse_uring_ent_avail(ring_ent, queue);
>> +       has_next = fuse_uring_ent_assign_req(ring_ent);
>> +       spin_unlock(&queue->lock);
>> +
>> +       if (has_next) {
>> +               err = fuse_uring_send_next_to_ring(ring_ent, issue_flags);
>> +               if (err)
>> +                       goto retry;
>> +       }
>> +}
>> +
>> +static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
>> +{
>> +       struct fuse_ring_queue *queue = ent->queue;
>> +
>> +       lockdep_assert_held(&queue->lock);
>> +
>> +       if (WARN_ON_ONCE(ent->state != FRRS_USERSPACE))
>> +               return -EIO;
>> +
>> +       ent->state = FRRS_COMMIT;
>> +       list_move(&ent->list, &queue->ent_commit_queue);
>> +
>> +       return 0;
>> +}
>> +
>> +/* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
>> +static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>> +                                  struct fuse_conn *fc)
>> +{
>> +       const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
>> +       struct fuse_ring_ent *ring_ent;
>> +       int err;
>> +       struct fuse_ring *ring = fc->ring;
>> +       struct fuse_ring_queue *queue;
>> +       uint64_t commit_id = READ_ONCE(cmd_req->commit_id);
>> +       unsigned int qid = READ_ONCE(cmd_req->qid);
>> +       struct fuse_pqueue *fpq;
>> +       struct fuse_req *req;
>> +
>> +       err = -ENOTCONN;
>> +       if (!ring)
>> +               return err;
>> +
>> +       if (qid >= ring->nr_queues)
>> +               return -EINVAL;
>> +
>> +       queue = ring->queues[qid];
>> +       if (!queue)
>> +               return err;
>> +       fpq = &queue->fpq;
>> +
>> +       spin_lock(&queue->lock);
>> +       /* Find a request based on the unique ID of the fuse request
>> +        * This should get revised, as it needs a hash calculation and list
>> +        * search. And full struct fuse_pqueue is needed (memory overhead).
>> +        * As well as the link from req to ring_ent.
>> +        */
> 
> imo, the hash calculation and list search seems ok. I can't think of a
> more optimal way of doing it. Instead of using the full struct
> fuse_pqueue, I think we could just have the "struct list_head
> *processing" defined inside "struct fuse_ring_queue" and change
> fuse_request_find() to take in a list_head. I don't think we need a
> dedicated spinlock for the list either. We can just reuse queue->lock,
> as that's (currently) always held already when the processing list is
> accessed.


Please see the attached patch, which uses xarray. Totally untested, though.
I actually found an issue while writing this patch - FR_PENDING was cleared
without holding fiq->lock, but that is important for request_wait_answer().
If something removes req from the list, we entirely loose the ring entry -
can never be used anymore. Personally I think the attached patch is safer.


> 
> 
>> +       req = fuse_request_find(fpq, commit_id);
>> +       err = -ENOENT;
>> +       if (!req) {
>> +               pr_info("qid=%d commit_id %llu not found\n", queue->qid,
>> +                       commit_id);
>> +               spin_unlock(&queue->lock);
>> +               return err;
>> +       }
>> +       list_del_init(&req->list);
>> +       ring_ent = req->ring_entry;
>> +       req->ring_entry = NULL;
> 
> Do we need to set this to NULL, given that the request will be cleaned
> up later in fuse_uring_req_end() anyways?

It is not explicitly set to NULL in that function. Would you mind to keep
it safe? 

> 
>> +
>> +       err = fuse_ring_ent_set_commit(ring_ent);
>> +       if (err != 0) {
>> +               pr_info_ratelimited("qid=%d commit_id %llu state %d",
>> +                                   queue->qid, commit_id, ring_ent->state);
>> +               spin_unlock(&queue->lock);
>> +               return err;
>> +       }
>> +
>> +       ring_ent->cmd = cmd;
>> +       spin_unlock(&queue->lock);
>> +
>> +       /* without the queue lock, as other locks are taken */
>> +       fuse_uring_commit(ring_ent, issue_flags);
>> +
>> +       /*
>> +        * Fetching the next request is absolutely required as queued
>> +        * fuse requests would otherwise not get processed - committing
>> +        * and fetching is done in one step vs legacy fuse, which has separated
>> +        * read (fetch request) and write (commit result).
>> +        */
>> +       fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
> 
> If there's no request ready to read next, then no request will be
> fetched and this will return. However, as I understand it, once the
> uring is registered, userspace should only be interacting with the
> uring via FUSE_IO_URING_CMD_COMMIT_AND_FETCH. However for the case
> where no request was ready to read, it seems like userspace would have
> nothing to commit when it wants to fetch the next request?

We have

FUSE_IO_URING_CMD_REGISTER 
FUSE_IO_URING_CMD_COMMIT_AND_FETCH


After _CMD_REGISTER the corresponding ring-entry is ready to get fuse
requests and waiting. After it gets a request assigned and handles it
by fuse server the _COMMIT_AND_FETCH scheme applies. Did you possibly
miss that _CMD_REGISTER will already have it waiting?


> 
> A more general question though: I imagine the most common use case
> from the server side is waiting / polling until there is a request to
> fetch. Could we not just do that here in the kernel instead with
> adding a waitqueue mechanism and having fuse_uring_next_fuse_req()
> only return when there is a request available? It seems like that
> would reduce the amount of overhead instead of doing the
> waiting/checking from the server side?

The io-uring interface says that we should return -EIOCBQUEUED. If we
would wait here, other SQEs that are submitted in parallel by
fuse-server couldn't be handled anymore, as we wouldn't return
to io-uring (all of this is in io-uring task context).

> 
>> +       return 0;
>> +}
>> +
>>  /*
>>   * fuse_uring_req_fetch command handling
>>   */
>> @@ -325,6 +767,14 @@ int __maybe_unused fuse_uring_cmd(struct io_uring_cmd *cmd,
>>                         return err;
>>                 }
>>                 break;
>> +       case FUSE_IO_URING_CMD_COMMIT_AND_FETCH:
>> +               err = fuse_uring_commit_fetch(cmd, issue_flags, fc);
>> +               if (err) {
>> +                       pr_info_once("FUSE_IO_URING_COMMIT_AND_FETCH failed err=%d\n",
>> +                                    err);
>> +                       return err;
>> +               }
>> +               break;
>>         default:
>>                 return -EINVAL;
>>         }
>> diff --git a/fs/fuse/dev_uring_i.h b/fs/fuse/dev_uring_i.h
>> index 4e46dd65196d26dabc62dada33b17de9aa511c08..80f1c62d4df7f0ca77c4d5179068df6ffdbf7d85 100644
>> --- a/fs/fuse/dev_uring_i.h
>> +++ b/fs/fuse/dev_uring_i.h
>> @@ -20,6 +20,9 @@ enum fuse_ring_req_state {
>>         /* The ring entry is waiting for new fuse requests */
>>         FRRS_AVAILABLE,
>>
>> +       /* The ring entry got assigned a fuse req */
>> +       FRRS_FUSE_REQ,
>> +
>>         /* The ring entry is in or on the way to user space */
>>         FRRS_USERSPACE,
>>  };
>> @@ -70,7 +73,16 @@ struct fuse_ring_queue {
>>          * entries in the process of being committed or in the process
>>          * to be sent to userspace
>>          */
>> +       struct list_head ent_w_req_queue;
> 
> What does the w in this stand for? I find the name ambiguous here.

"entry-with-request-queue".  Do you have another naming suggestion?


Thanks,
Bernd


--------------qh4PRPzea2n8fvqt04svWEYP
Content-Type: text/x-patch; charset=UTF-8; name="ent-xarray.patch"
Content-Disposition: attachment; filename="ent-xarray.patch"
Content-Transfer-Encoding: base64

Y29tbWl0IDQ4ZWFjZjQ3ZmMyZjZhNmEyYmFiMzU1Nzk0NTE4MjUyODJlYjRmMWYKQXV0aG9y
OiBCZXJuZCBTY2h1YmVydCA8YnNjaHViZXJ0QGRkbi5jb20+CkRhdGU6ICAgTW9uIEphbiAy
MCAwMDozNDo0MSAyMDI1ICswMTAwCgogICAgeGFycmF5CgpkaWZmIC0tZ2l0IGEvZnMvZnVz
ZS9kZXZfdXJpbmcuYyBiL2ZzL2Z1c2UvZGV2X3VyaW5nLmMKaW5kZXggNDBhMGMxOWFiNGQ3
Li5iOGQyY2VhMWY3MmIgMTAwNjQ0Ci0tLSBhL2ZzL2Z1c2UvZGV2X3VyaW5nLmMKKysrIGIv
ZnMvZnVzZS9kZXZfdXJpbmcuYwpAQCAtNyw2ICs3LDcgQEAKICNpbmNsdWRlICJmdXNlX2ku
aCIKICNpbmNsdWRlICJkZXZfdXJpbmdfaS5oIgogI2luY2x1ZGUgImZ1c2VfZGV2X2kuaCIK
KyNpbmNsdWRlIDxsaW51eC94YXJyYXkuaD4KIAogI2luY2x1ZGUgPGxpbnV4L2ZzLmg+CiAj
aW5jbHVkZSA8bGludXgvaW9fdXJpbmcvY21kLmg+CkBAIC01NSw3ICs1Niw2IEBAIHZvaWQg
ZnVzZV91cmluZ19kZXN0cnVjdChzdHJ1Y3QgZnVzZV9jb25uICpmYykKIAkJV0FSTl9PTigh
bGlzdF9lbXB0eSgmcXVldWUtPmVudF9jb21taXRfcXVldWUpKTsKIAkJV0FSTl9PTighbGlz
dF9lbXB0eSgmcXVldWUtPmVudF9pbl91c2Vyc3BhY2UpKTsKIAotCQlrZnJlZShxdWV1ZS0+
ZnBxLnByb2Nlc3NpbmcpOwogCQlrZnJlZShxdWV1ZSk7CiAJCXJpbmctPnF1ZXVlc1txaWRd
ID0gTlVMTDsKIAl9CkBAIC0xMzUsMTMgKzEzNSwxMSBAQCBzdGF0aWMgc3RydWN0IGZ1c2Vf
cmluZ19xdWV1ZSAqZnVzZV91cmluZ19jcmVhdGVfcXVldWUoc3RydWN0IGZ1c2VfcmluZyAq
cmluZywKIAlJTklUX0xJU1RfSEVBRCgmcXVldWUtPmVudF9pbl91c2Vyc3BhY2UpOwogCUlO
SVRfTElTVF9IRUFEKCZxdWV1ZS0+ZnVzZV9yZXFfcXVldWUpOwogCi0JcXVldWUtPmZwcS5w
cm9jZXNzaW5nID0gcHE7Ci0JZnVzZV9wcXVldWVfaW5pdCgmcXVldWUtPmZwcSk7CisJeGFf
aW5pdCgmcXVldWUtPmVudF94YSk7CiAKIAlzcGluX2xvY2soJmZjLT5sb2NrKTsKIAlpZiAo
cmluZy0+cXVldWVzW3FpZF0pIHsKIAkJc3Bpbl91bmxvY2soJmZjLT5sb2NrKTsKLQkJa2Zy
ZWUocXVldWUtPmZwcS5wcm9jZXNzaW5nKTsKIAkJa2ZyZWUocXVldWUpOwogCQlyZXR1cm4g
cmluZy0+cXVldWVzW3FpZF07CiAJfQpAQCAtMjQwLDcgKzIzOCw3IEBAIHN0YXRpYyBpbnQg
ZnVzZV91cmluZ19hcmdzX3RvX3Jpbmcoc3RydWN0IGZ1c2VfcmluZyAqcmluZywgc3RydWN0
IGZ1c2VfcmVxICpyZXEsCiAJc3RydWN0IGlvdl9pdGVyIGl0ZXI7CiAJc3RydWN0IGZ1c2Vf
dXJpbmdfZW50X2luX291dCBlbnRfaW5fb3V0ID0gewogCQkuZmxhZ3MgPSAwLAotCQkuY29t
bWl0X2lkID0gcmVxLT5pbi5oLnVuaXF1ZSwKKwkJLmNvbW1pdF9pZCA9IGVudC0+aWQKIAl9
OwogCiAJZXJyID0gaW1wb3J0X3VidWYoSVRFUl9ERVNULCBlbnQtPnBheWxvYWQsIHJpbmct
Pm1heF9wYXlsb2FkX3N6LCAmaXRlcik7CkBAIC0zNzMsMTkgKzM3MSw2IEBAIHN0YXRpYyB2
b2lkIGZ1c2VfdXJpbmdfZW50X2F2YWlsKHN0cnVjdCBmdXNlX3JpbmdfZW50ICplbnQsCiAJ
ZW50LT5zdGF0ZSA9IEZSUlNfQVZBSUxBQkxFOwogfQogCi0vKiBVc2VkIHRvIGZpbmQgdGhl
IHJlcXVlc3Qgb24gU1FFIGNvbW1pdCAqLwotc3RhdGljIHZvaWQgZnVzZV91cmluZ19hZGRf
dG9fcHEoc3RydWN0IGZ1c2VfcmluZ19lbnQgKmVudCwKLQkJCQkgc3RydWN0IGZ1c2VfcmVx
ICpyZXEpCi17Ci0Jc3RydWN0IGZ1c2VfcmluZ19xdWV1ZSAqcXVldWUgPSBlbnQtPnF1ZXVl
OwotCXN0cnVjdCBmdXNlX3BxdWV1ZSAqZnBxID0gJnF1ZXVlLT5mcHE7Ci0JdW5zaWduZWQg
aW50IGhhc2g7Ci0KLQlyZXEtPnJpbmdfZW50cnkgPSBlbnQ7Ci0JaGFzaCA9IGZ1c2VfcmVx
X2hhc2gocmVxLT5pbi5oLnVuaXF1ZSk7Ci0JbGlzdF9tb3ZlX3RhaWwoJnJlcS0+bGlzdCwg
JmZwcS0+cHJvY2Vzc2luZ1toYXNoXSk7Ci19Ci0KIC8qCiAgKiBBc3NpZ24gYSBmdXNlIHF1
ZXVlIGVudHJ5IHRvIHRoZSBnaXZlbiBlbnRyeQogICovCkBAIC00MTAsNyArMzk1LDkgQEAg
c3RhdGljIHZvaWQgZnVzZV91cmluZ19hZGRfcmVxX3RvX3JpbmdfZW50KHN0cnVjdCBmdXNl
X3JpbmdfZW50ICplbnQsCiAJZW50LT5mdXNlX3JlcSA9IHJlcTsKIAllbnQtPnN0YXRlID0g
RlJSU19GVVNFX1JFUTsKIAlsaXN0X21vdmUoJmVudC0+bGlzdCwgJnF1ZXVlLT5lbnRfd19y
ZXFfcXVldWUpOwotCWZ1c2VfdXJpbmdfYWRkX3RvX3BxKGVudCwgcmVxKTsKKworCVdBUk5f
T05fT05DRSghbGlzdF9lbXB0eSgmZW50LT5wcm9jX2xpc3QpKTsKKwlsaXN0X21vdmVfdGFp
bCgmcmVxLT5saXN0LCAmZW50LT5wcm9jX2xpc3QpOwogfQogCiAvKgpAQCAtNDUwLDYgKzQz
NywxNSBAQCBzdGF0aWMgdm9pZCBmdXNlX3VyaW5nX2NvbW1pdChzdHJ1Y3QgZnVzZV9yaW5n
X2VudCAqZW50LAogCXN0cnVjdCBmdXNlX3JlcSAqcmVxID0gZW50LT5mdXNlX3JlcTsKIAlz
c2l6ZV90IGVyciA9IDA7CiAKKwkvKgorCSAqIFRoZSByZXF1ZXN0IHdhcyByZW1vdmVkIGZy
b20gcHJvY19saXN0IC0gd2UgYXJlIG5vdCBnb2luZyB0byBmdXJ0aGVyCisJICogcHJvY2Vz
cyBpdAorCSAqLworCWlmIChsaXN0X2VtcHR5KCZlbnQtPnByb2NfbGlzdCkpCisJCXJldHVy
bjsKKworCWxpc3RfZGVsX2luaXQoJnJlcS0+bGlzdCk7CisKIAllcnIgPSBjb3B5X2Zyb21f
dXNlcigmcmVxLT5vdXQuaCwgJmVudC0+aGVhZGVycy0+aW5fb3V0LAogCQkJICAgICBzaXpl
b2YocmVxLT5vdXQuaCkpOwogCWlmIChlcnIpIHsKQEAgLTUwNiw2ICs1MDIsMTIgQEAgc3Rh
dGljIGludCBmdXNlX3JpbmdfZW50X3NldF9jb21taXQoc3RydWN0IGZ1c2VfcmluZ19lbnQg
KmVudCkKIAlyZXR1cm4gMDsKIH0KIAorc3RhdGljIHN0cnVjdCBmdXNlX3JpbmdfZW50ICoK
K2Z1c2VfdXJpbmdfZmluZF9yaW5nX2VudChzdHJ1Y3QgZnVzZV9yaW5nX3F1ZXVlICpxdWV1
ZSwgdTMyIGlkKQoreworCXJldHVybiB4YV9sb2FkKCZxdWV1ZS0+ZW50X3hhLCBpZCk7Cit9
CisKIC8qIEZVU0VfVVJJTkdfQ01EX0NPTU1JVF9BTkRfRkVUQ0ggaGFuZGxlciAqLwogc3Rh
dGljIGludCBmdXNlX3VyaW5nX2NvbW1pdF9mZXRjaChzdHJ1Y3QgaW9fdXJpbmdfY21kICpj
bWQsIGludCBpc3N1ZV9mbGFncywKIAkJCQkgICBzdHJ1Y3QgZnVzZV9jb25uICpmYykKQEAg
LTUxNyw3ICs1MTksNiBAQCBzdGF0aWMgaW50IGZ1c2VfdXJpbmdfY29tbWl0X2ZldGNoKHN0
cnVjdCBpb191cmluZ19jbWQgKmNtZCwgaW50IGlzc3VlX2ZsYWdzLAogCXN0cnVjdCBmdXNl
X3JpbmdfcXVldWUgKnF1ZXVlOwogCXVpbnQ2NF90IGNvbW1pdF9pZCA9IFJFQURfT05DRShj
bWRfcmVxLT5jb21taXRfaWQpOwogCXVuc2lnbmVkIGludCBxaWQgPSBSRUFEX09OQ0UoY21k
X3JlcS0+cWlkKTsKLQlzdHJ1Y3QgZnVzZV9wcXVldWUgKmZwcTsKIAlzdHJ1Y3QgZnVzZV9y
ZXEgKnJlcTsKIAogCWVyciA9IC1FTk9UQ09OTjsKQEAgLTUzMCwyOCArNTMxLDIwIEBAIHN0
YXRpYyBpbnQgZnVzZV91cmluZ19jb21taXRfZmV0Y2goc3RydWN0IGlvX3VyaW5nX2NtZCAq
Y21kLCBpbnQgaXNzdWVfZmxhZ3MsCiAJcXVldWUgPSByaW5nLT5xdWV1ZXNbcWlkXTsKIAlp
ZiAoIXF1ZXVlKQogCQlyZXR1cm4gZXJyOwotCWZwcSA9ICZxdWV1ZS0+ZnBxOwogCiAJc3Bp
bl9sb2NrKCZxdWV1ZS0+bG9jayk7Ci0JLyogRmluZCBhIHJlcXVlc3QgYmFzZWQgb24gdGhl
IHVuaXF1ZSBJRCBvZiB0aGUgZnVzZSByZXF1ZXN0Ci0JICogVGhpcyBzaG91bGQgZ2V0IHJl
dmlzZWQsIGFzIGl0IG5lZWRzIGEgaGFzaCBjYWxjdWxhdGlvbiBhbmQgbGlzdAotCSAqIHNl
YXJjaC4gQW5kIGZ1bGwgc3RydWN0IGZ1c2VfcHF1ZXVlIGlzIG5lZWRlZCAobWVtb3J5IG92
ZXJoZWFkKS4KLQkgKiBBcyB3ZWxsIGFzIHRoZSBsaW5rIGZyb20gcmVxIHRvIHJpbmdfZW50
LgotCSAqLwotCXJlcSA9IGZ1c2VfcmVxdWVzdF9maW5kKGZwcSwgY29tbWl0X2lkKTsKKwog
CWVyciA9IC1FTk9FTlQ7Ci0JaWYgKCFyZXEpIHsKLQkJcHJfaW5mbygicWlkPSVkIGNvbW1p
dF9pZCAlbGx1IG5vdCBmb3VuZFxuIiwgcXVldWUtPnFpZCwKLQkJCWNvbW1pdF9pZCk7CisJ
ZW50ID0gZnVzZV91cmluZ19maW5kX3JpbmdfZW50KHF1ZXVlLCBjb21taXRfaWQpOworCWlm
ICghZW50KSB7CiAJCXNwaW5fdW5sb2NrKCZxdWV1ZS0+bG9jayk7CiAJCXJldHVybiBlcnI7
CiAJfQotCWxpc3RfZGVsX2luaXQoJnJlcS0+bGlzdCk7Ci0JZW50ID0gcmVxLT5yaW5nX2Vu
dHJ5OwotCXJlcS0+cmluZ19lbnRyeSA9IE5VTEw7CisKKwlyZXEgPSBlbnQtPmZ1c2VfcmVx
OwogCiAJZXJyID0gZnVzZV9yaW5nX2VudF9zZXRfY29tbWl0KGVudCk7Ci0JaWYgKGVyciAh
PSAwKSB7CisJaWYgKGVyciAhPSAwICYmICFsaXN0X2VtcHR5KCZlbnQtPnByb2NfbGlzdCkp
IHsKIAkJcHJfaW5mb19yYXRlbGltaXRlZCgicWlkPSVkIGNvbW1pdF9pZCAlbGx1IHN0YXRl
ICVkIiwKIAkJCQkgICAgcXVldWUtPnFpZCwgY29tbWl0X2lkLCBlbnQtPnN0YXRlKTsKIAkJ
c3Bpbl91bmxvY2soJnF1ZXVlLT5sb2NrKTsKQEAgLTY1OCwxMSArNjUxLDE5IEBAIGZ1c2Vf
dXJpbmdfY3JlYXRlX3JpbmdfZW50KHN0cnVjdCBpb191cmluZ19jbWQgKmNtZCwKIAkJcmV0
dXJuIEVSUl9QVFIoZXJyKTsKIAogCUlOSVRfTElTVF9IRUFEKCZlbnQtPmxpc3QpOworCUlO
SVRfTElTVF9IRUFEKCZlbnQtPnByb2NfbGlzdCk7CiAKIAllbnQtPnF1ZXVlID0gcXVldWU7
CiAJZW50LT5oZWFkZXJzID0gaW92WzBdLmlvdl9iYXNlOwogCWVudC0+cGF5bG9hZCA9IGlv
dlsxXS5pb3ZfYmFzZTsKIAorCS8vIEdlbmVyYXRlIGEgdW5pcXVlIElEIGFuZCBhZGQgdG8g
WEFycmF5CisJZXJyID0geGFfYWxsb2MoJnF1ZXVlLT5lbnRfeGEsICZlbnQtPmlkLCBlbnQs
IHhhX2xpbWl0XzMyYiwgR0ZQX0tFUk5FTCk7CisJaWYgKGVycikgeworCQlrZnJlZShlbnQp
OworCQlyZXR1cm4gRVJSX1BUUihlcnIpOworCX0KKwogCXJldHVybiBlbnQ7CiB9CiAKZGlm
ZiAtLWdpdCBhL2ZzL2Z1c2UvZGV2X3VyaW5nX2kuaCBiL2ZzL2Z1c2UvZGV2X3VyaW5nX2ku
aAppbmRleCA0NGJmMjM3ZjBkNWEuLmI3N2YxYTQ4NWM4YiAxMDA2NDQKLS0tIGEvZnMvZnVz
ZS9kZXZfdXJpbmdfaS5oCisrKyBiL2ZzL2Z1c2UvZGV2X3VyaW5nX2kuaApAQCAtNDQsNyAr
NDQsMTYgQEAgc3RydWN0IGZ1c2VfcmluZ19lbnQgewogCiAJZW51bSBmdXNlX3JpbmdfcmVx
X3N0YXRlIHN0YXRlOwogCisJLyoKKwkgKiBwcm9jZXNzaW5nIHF1ZXVlLCBhcyBsaXN0IHRv
IGNvbXBseSB3aXRoIHJlbWFpbmluZyBmdXNlIGNvZGUKKwkgKiB0aGF0IGV4cGVjdHMgdGhl
IGVudHJ5IG9uIGEgbGlzdCBhbmQgbWlnaHQgYWxzbyByZW1vdmUgaXQKKwkgKiBmcm9tIHRo
ZSBsaXN0CisJICovCisJc3RydWN0IGxpc3RfaGVhZCBwcm9jX2xpc3Q7CisKIAlzdHJ1Y3Qg
ZnVzZV9yZXEgKmZ1c2VfcmVxOworCisJdTMyIGlkOyAvKiBlbnRyeSBJRCovCiB9OwogCiBz
dHJ1Y3QgZnVzZV9yaW5nX3F1ZXVlIHsKQEAgLTc5LDcgKzg4LDggQEAgc3RydWN0IGZ1c2Vf
cmluZ19xdWV1ZSB7CiAJLyogZnVzZSByZXF1ZXN0cyB3YWl0aW5nIGZvciBhbiBlbnRyeSBz
bG90ICovCiAJc3RydWN0IGxpc3RfaGVhZCBmdXNlX3JlcV9xdWV1ZTsKIAotCXN0cnVjdCBm
dXNlX3BxdWV1ZSBmcHE7CisJLyogWEFycmF5IHRvIHN0b3JlIGFuZCBmaW5kIHJpbmcgZW50
cmllcyAqLworCXN0cnVjdCB4YXJyYXkgZW50X3hhOwogfTsKIAogLyoqCg==

--------------qh4PRPzea2n8fvqt04svWEYP--

