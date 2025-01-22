Return-Path: <io-uring+bounces-6035-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8001BA188D0
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 01:18:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B48EC1616E7
	for <lists+io-uring@lfdr.de>; Wed, 22 Jan 2025 00:18:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1C0554409;
	Wed, 22 Jan 2025 00:18:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b="L7biOfFi";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="Lc/qb6bj"
X-Original-To: io-uring@vger.kernel.org
Received: from fhigh-b7-smtp.messagingengine.com (fhigh-b7-smtp.messagingengine.com [202.12.124.158])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 84C003A1B6;
	Wed, 22 Jan 2025 00:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=202.12.124.158
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737505113; cv=none; b=Z3bsPpw8b9GUhpx8HtCyUSrKwBvwuz6W1/wk8SVOQ3EMGRTpkQ4HCsvrlbKhe2uQ6Ay0pVrp4FaZo/QXxR702PnrThfUr/SDNSVNh1CAsWGws9Sc/YSJ3S7f0vH25s6XpchC+hCjLKQ9WxXt/b6FerXNGmhz4VHfAAXWDQcWxmw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737505113; c=relaxed/simple;
	bh=jeDzPFwJsZqcGpG2v/vUvvzuZVImyG/GQP7tc1RKL6w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EP57dhMoiB/lV9VcfPOWofuGP5HyCbjs6dTC3bv1t4wnIQXhzMdlJqCMgqR2tGynF7vQvpdI/ei552RbspIhf94gLMzP7JiO9N7YR0abCLUiCaFzqLQA8kDVeI/OXomHFODShZzUvTLdyONlRN6eTRRjhTxCJnYWvLe4Wnlm4ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com; spf=pass smtp.mailfrom=bsbernd.com; dkim=pass (2048-bit key) header.d=bsbernd.com header.i=@bsbernd.com header.b=L7biOfFi; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=Lc/qb6bj; arc=none smtp.client-ip=202.12.124.158
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=bsbernd.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bsbernd.com
Received: from phl-compute-04.internal (phl-compute-04.phl.internal [10.202.2.44])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 2ABFD2540222;
	Tue, 21 Jan 2025 19:18:28 -0500 (EST)
Received: from phl-mailfrontend-02 ([10.202.2.163])
  by phl-compute-04.internal (MEProxy); Tue, 21 Jan 2025 19:18:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bsbernd.com; h=
	cc:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1737505108;
	 x=1737591508; bh=GyCz/AdkyxEW20o7ZofuNkkh00+zeaBNXSP8hzOegHY=; b=
	L7biOfFi1kpYpynXqJvs3kEQwyrUTrUYub2grP3I97W0XfrQpXS6IJj0PM/srR4z
	4G6aXtqorFDBhmFzqtZRVFdztbVjeb0zEx4Z/5psfJDy2/iM6X4TQvDn6qmr+x9Q
	k8by+7Yx13DV/SfRe2+OOROx4yddQheSoJxpNpCenPSRu01hfirB0TLVg1jExxzp
	qd5IgPxfuJyaIMeJzXyBeCLIMvI688gL9f9uKY99VQS83WkeKr9v8VvUq0CWcdBS
	LpbbiRgKpS0J0AfUdzCdbhFQBdtZDZF5xvt6bGuNMnRgqGJquzOhwN9zAsEWzEY/
	7kNh2sLwINNgGC8/dgtjxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=1737505108; x=
	1737591508; bh=GyCz/AdkyxEW20o7ZofuNkkh00+zeaBNXSP8hzOegHY=; b=L
	c/qb6bjf0C6niBScgDa0gS7QIM4E8t+4PsY3u095xFaNo3isCHjULor8NMFSrefB
	rNwLF4qQQ0Q06J3soezQwbEG9kmhMCZgxYXGA7AqGvdA3dcEYK11apJaJcZjQh3J
	1qN5E/hHCUd4VdOqIq13sLBzE05bE1LA3tUM0uZGbBYYHhTP2SNpiPrPlcBYncsE
	xcP+PFJKDeWL1SKgF1PufWd9iCpCu4juEfx5WKb14Vmn7hKfkA1f/jNKCufvOBa/
	y0W9YYqHYEgTqRpgWtbuV3zsWHiE6mQJh+41fXn118gHOHX1mRUXYiEnacAY+nVI
	Zvj1zD6lzYojbnjZuMtGA==
X-ME-Sender: <xms:UjmQZ_V9MoTiwZs0lMOtQBS1wRgSQclKhd-Ngz7jbfubK9FZWx1lYQ>
    <xme:UjmQZ3nbe4JEwYaC5xDoKD2szFfLlxbZt7amUNGqBNlE7-ccBai96FLB3X6suxQEl
    rHRlohI022YaEfM>
X-ME-Received: <xmr:UjmQZ7aA1w5DKh4Xejmu1b3EDFhQUuM99HKHaL88LvCbuO5L02vF18LxDx7xAgwe5vI2L66EEQqRVE0Lz-CNcUeN8mf250-Q5zTy8COZcv988h0RU7R4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefuddrudejfedgvdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnecujfgurhepkfffgggfuffvvehfhfgjtgfgsehtkeertddtvdej
    necuhfhrohhmpeeuvghrnhguucfutghhuhgsvghrthcuoegsvghrnhgusegsshgsvghrnh
    gurdgtohhmqeenucggtffrrghtthgvrhhnpeefgeegfeffkeduudelfeehleelhefgffeh
    udejvdfgteevvddtfeeiheeflefgvdenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsvghrnhgusegsshgsvghrnhgurdgtohhmpdhnsggprhgt
    phhtthhopeduuddpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepjhhorghnnhgvlh
    hkohhonhhgsehgmhgrihhlrdgtohhmpdhrtghpthhtohepsghstghhuhgsvghrthesuggu
    nhdrtghomhdprhgtphhtthhopehmihhklhhoshesshiivghrvgguihdrhhhupdhrtghpth
    htoheprgigsghovgeskhgvrhhnvghlrdgukhdprhgtphhtthhopegrshhmlhdrshhilhgv
    nhgtvgesghhmrghilhdrtghomhdprhgtphhtthhopehlihhnuhigqdhfshguvghvvghlse
    hvghgvrhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepihhoqdhurhhinhhgsehvghgv
    rhdrkhgvrhhnvghlrdhorhhgpdhrtghpthhtohepjhhoshgvfhesthhogihitghprghnug
    grrdgtohhmpdhrtghpthhtoheprghmihhrjeefihhlsehgmhgrihhlrdgtohhm
X-ME-Proxy: <xmx:UjmQZ6W9ELB6M4HQFZRDMK_A_CVLyBXj-A6SXnqcm7hW-unefVsVqA>
    <xmx:UjmQZ5nB4icCamaspAzoToSA4B968NXJ9i8NAXAP4Eq-n0a4Zn6Esg>
    <xmx:UjmQZ3eAbl3mMUzPFNhmsKmf7yEbSvpZ0_4jsEmxw7uwY0ZrL4LeDg>
    <xmx:UjmQZzEuySHQCDUKJOgHDp2Q405LDmoLyL5IFebsCjwV74JkMcGOqA>
    <xmx:UzmQZ88cURv3IRvJTfeOFsz0bBkdReaGMZxkTOYxY0jppfDjP9nWRsAn>
Feedback-ID: i5c2e48a5:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 21 Jan 2025 19:18:25 -0500 (EST)
Message-ID: <605815bc-40ca-49c1-a727-a36f961b8ad6@bsbernd.com>
Date: Wed, 22 Jan 2025 01:18:23 +0100
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 10/17] fuse: Add io-uring sqe commit and fetch support
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Bernd Schubert <bschubert@ddn.com>, Miklos Szeredi <miklos@szeredi.hu>,
 Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>,
 linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
 Josef Bacik <josef@toxicpanda.com>, Amir Goldstein <amir73il@gmail.com>,
 Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>
References: <20250107-fuse-uring-for-6-10-rfc4-v9-0-9c786f9a7a9d@ddn.com>
 <20250107-fuse-uring-for-6-10-rfc4-v9-10-9c786f9a7a9d@ddn.com>
 <CAJnrk1afYmo+GNRb=OF7CUQzY5ocEus0h=93ax8usA9oa_qM4Q@mail.gmail.com>
 <eafad58d-07ec-4e7f-9482-26f313f066cc@bsbernd.com>
 <CAJnrk1asVwkm8kG-Rfmgi-gPXjYxA8HcA_vauqVi+zjuPNtaJQ@mail.gmail.com>
From: Bernd Schubert <bernd@bsbernd.com>
Content-Language: en-US, de-DE, fr
In-Reply-To: <CAJnrk1asVwkm8kG-Rfmgi-gPXjYxA8HcA_vauqVi+zjuPNtaJQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit



On 1/22/25 01:04, Joanne Koong wrote:
> On Sun, Jan 19, 2025 at 4:33 PM Bernd Schubert <bernd@bsbernd.com> wrote:
>>
>> Hi Joanne,
>>
>> sorry for my late reply, I was occupied all week.
>>
>> On 1/13/25 23:44, Joanne Koong wrote:
>>> On Mon, Jan 6, 2025 at 4:25 PM Bernd Schubert <bschubert@ddn.com> wrote:
>>>>
>>>> This adds support for fuse request completion through ring SQEs
>>>> (FUSE_URING_CMD_COMMIT_AND_FETCH handling). After committing
>>>> the ring entry it becomes available for new fuse requests.
>>>> Handling of requests through the ring (SQE/CQE handling)
>>>> is complete now.
>>>>
>>>> Fuse request data are copied through the mmaped ring buffer,
>>>> there is no support for any zero copy yet.
>>>>
>>>> Signed-off-by: Bernd Schubert <bschubert@ddn.com>
>>>> ---
>>>>  fs/fuse/dev_uring.c   | 450 ++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  fs/fuse/dev_uring_i.h |  12 ++
>>>>  fs/fuse/fuse_i.h      |   4 +
>>>>  3 files changed, 466 insertions(+)
>>>>
>>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
>>>> index b44ba4033615e01041313c040035b6da6af0ee17..f44e66a7ea577390da87e9ac7d118a9416898c28 100644
>>>> --- a/fs/fuse/dev_uring.c
>>>> +++ b/fs/fuse/dev_uring.c
>>>> @@ -26,6 +26,19 @@ bool fuse_uring_enabled(void)
>>>>         return enable_uring;
>>>>  }
>>>>
>>>> +static void fuse_uring_req_end(struct fuse_ring_ent *ring_ent, bool set_err,
>>>> +                              int error)
>>>> +{
>>>> +       struct fuse_req *req = ring_ent->fuse_req;
>>>> +
>>>> +       if (set_err)
>>>> +               req->out.h.error = error;
>>>
>>> I think we could get away with not having the "bool set_err" as an
>>> argument if we do "if (error)" directly. AFAICT, we can use the value
>>> of error directly since  it always returns zero on success and any
>>> non-zero value is considered an error.
>>
>> I had done this because of fuse_uring_commit()
>>
>>
>>         err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
>>         if (err) {
>>                 /* req->out.h.error already set */
>>                 goto out;
>>         }
>>
>>
>> In fuse_uring_out_header_has_err() the header might already have the
>> error code, but there are other errors as well. Well, setting an
>> existing error code saves us a few lines and conditions, so you are
>> probably right and I removed that argument now.
>>
>>
>>>
>>>> +
>>>> +       clear_bit(FR_SENT, &req->flags);
>>>> +       fuse_request_end(ring_ent->fuse_req);
>>>> +       ring_ent->fuse_req = NULL;
>>>> +}
>>>> +
>>>>  void fuse_uring_destruct(struct fuse_conn *fc)
>>>>  {
>>>>         struct fuse_ring *ring = fc->ring;
>>>> @@ -41,8 +54,11 @@ void fuse_uring_destruct(struct fuse_conn *fc)
>>>>                         continue;
>>>>
>>>>                 WARN_ON(!list_empty(&queue->ent_avail_queue));
>>>> +               WARN_ON(!list_empty(&queue->ent_w_req_queue));
>>>>                 WARN_ON(!list_empty(&queue->ent_commit_queue));
>>>> +               WARN_ON(!list_empty(&queue->ent_in_userspace));
>>>>
>>>> +               kfree(queue->fpq.processing);
>>>>                 kfree(queue);
>>>>                 ring->queues[qid] = NULL;
>>>>         }
>>>> @@ -101,20 +117,34 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>>>>  {
>>>>         struct fuse_conn *fc = ring->fc;
>>>>         struct fuse_ring_queue *queue;
>>>> +       struct list_head *pq;
>>>>
>>>>         queue = kzalloc(sizeof(*queue), GFP_KERNEL_ACCOUNT);
>>>>         if (!queue)
>>>>                 return NULL;
>>>> +       pq = kcalloc(FUSE_PQ_HASH_SIZE, sizeof(struct list_head), GFP_KERNEL);
>>>> +       if (!pq) {
>>>> +               kfree(queue);
>>>> +               return NULL;
>>>> +       }
>>>> +
>>>>         queue->qid = qid;
>>>>         queue->ring = ring;
>>>>         spin_lock_init(&queue->lock);
>>>>
>>>>         INIT_LIST_HEAD(&queue->ent_avail_queue);
>>>>         INIT_LIST_HEAD(&queue->ent_commit_queue);
>>>> +       INIT_LIST_HEAD(&queue->ent_w_req_queue);
>>>> +       INIT_LIST_HEAD(&queue->ent_in_userspace);
>>>> +       INIT_LIST_HEAD(&queue->fuse_req_queue);
>>>> +
>>>> +       queue->fpq.processing = pq;
>>>> +       fuse_pqueue_init(&queue->fpq);
>>>>
>>>>         spin_lock(&fc->lock);
>>>>         if (ring->queues[qid]) {
>>>>                 spin_unlock(&fc->lock);
>>>> +               kfree(queue->fpq.processing);
>>>>                 kfree(queue);
>>>>                 return ring->queues[qid];
>>>>         }
>>>> @@ -128,6 +158,214 @@ static struct fuse_ring_queue *fuse_uring_create_queue(struct fuse_ring *ring,
>>>>         return queue;
>>>>  }
>>>>
>>>> +/*
>>>> + * Checks for errors and stores it into the request
>>>> + */
>>>> +static int fuse_uring_out_header_has_err(struct fuse_out_header *oh,
>>>> +                                        struct fuse_req *req,
>>>> +                                        struct fuse_conn *fc)
>>>> +{
>>>> +       int err;
>>>> +
>>>> +       err = -EINVAL;
>>>> +       if (oh->unique == 0) {
>>>> +               /* Not supportd through io-uring yet */
>>>> +               pr_warn_once("notify through fuse-io-uring not supported\n");
>>>> +               goto seterr;
>>>> +       }
>>>> +
>>>> +       err = -EINVAL;
>>>> +       if (oh->error <= -ERESTARTSYS || oh->error > 0)
>>>> +               goto seterr;
>>>> +
>>>> +       if (oh->error) {
>>>> +               err = oh->error;
>>>> +               goto err;
>>>> +       }
>>>> +
>>>> +       err = -ENOENT;
>>>> +       if ((oh->unique & ~FUSE_INT_REQ_BIT) != req->in.h.unique) {
>>>> +               pr_warn_ratelimited("unique mismatch, expected: %llu got %llu\n",
>>>> +                                   req->in.h.unique,
>>>> +                                   oh->unique & ~FUSE_INT_REQ_BIT);
>>>> +               goto seterr;
>>>> +       }
>>>> +
>>>> +       /*
>>>> +        * Is it an interrupt reply ID?
>>>> +        * XXX: Not supported through fuse-io-uring yet, it should not even
>>>> +        *      find the request - should not happen.
>>>> +        */
>>>> +       WARN_ON_ONCE(oh->unique & FUSE_INT_REQ_BIT);
>>>> +
>>>> +       return 0;
>>>> +
>>>> +seterr:
>>>> +       oh->error = err;
>>>> +err:
>>>> +       return err;
>>>> +}
>>>> +
>>>> +static int fuse_uring_copy_from_ring(struct fuse_ring *ring,
>>>> +                                    struct fuse_req *req,
>>>> +                                    struct fuse_ring_ent *ent)
>>>> +{
>>>> +       struct fuse_copy_state cs;
>>>> +       struct fuse_args *args = req->args;
>>>> +       struct iov_iter iter;
>>>> +       int err, res;
>>>> +       struct fuse_uring_ent_in_out ring_in_out;
>>>> +
>>>> +       res = copy_from_user(&ring_in_out, &ent->headers->ring_ent_in_out,
>>>> +                            sizeof(ring_in_out));
>>>> +       if (res)
>>>> +               return -EFAULT;
>>>> +
>>>> +       err = import_ubuf(ITER_SOURCE, ent->payload, ring->max_payload_sz,
>>>> +                         &iter);
>>>> +       if (err)
>>>> +               return err;
>>>> +
>>>> +       fuse_copy_init(&cs, 0, &iter);
>>>> +       cs.is_uring = 1;
>>>> +       cs.req = req;
>>>> +
>>>> +       return fuse_copy_out_args(&cs, args, ring_in_out.payload_sz);
>>>> +}
>>>> +
>>>> + /*
>>>> +  * Copy data from the req to the ring buffer
>>>> +  */
>>>> +static int fuse_uring_copy_to_ring(struct fuse_ring *ring, struct fuse_req *req,
>>>> +                                  struct fuse_ring_ent *ent)
>>>> +{
>>>> +       struct fuse_copy_state cs;
>>>> +       struct fuse_args *args = req->args;
>>>> +       struct fuse_in_arg *in_args = args->in_args;
>>>> +       int num_args = args->in_numargs;
>>>> +       int err, res;
>>>> +       struct iov_iter iter;
>>>> +       struct fuse_uring_ent_in_out ent_in_out = {
>>>> +               .flags = 0,
>>>> +               .commit_id = ent->commit_id,
>>>> +       };
>>>> +
>>>> +       if (WARN_ON(ent_in_out.commit_id == 0))
>>>> +               return -EINVAL;
>>>> +
>>>> +       err = import_ubuf(ITER_DEST, ent->payload, ring->max_payload_sz, &iter);
>>>> +       if (err) {
>>>> +               pr_info_ratelimited("fuse: Import of user buffer failed\n");
>>>> +               return err;
>>>> +       }
>>>> +
>>>> +       fuse_copy_init(&cs, 1, &iter);
>>>> +       cs.is_uring = 1;
>>>> +       cs.req = req;
>>>> +
>>>> +       if (num_args > 0) {
>>>> +               /*
>>>> +                * Expectation is that the first argument is the per op header.
>>>> +                * Some op code have that as zero.
>>>> +                */
>>>> +               if (args->in_args[0].size > 0) {
>>>> +                       res = copy_to_user(&ent->headers->op_in, in_args->value,
>>>> +                                          in_args->size);
>>>> +                       err = res > 0 ? -EFAULT : res;
>>>> +                       if (err) {
>>>> +                               pr_info_ratelimited(
>>>> +                                       "Copying the header failed.\n");
>>>> +                               return err;
>>>> +                       }
>>>> +               }
>>>> +               in_args++;
>>>> +               num_args--;
>>>> +       }
>>>> +
>>>> +       /* copy the payload */
>>>> +       err = fuse_copy_args(&cs, num_args, args->in_pages,
>>>> +                            (struct fuse_arg *)in_args, 0);
>>>> +       if (err) {
>>>> +               pr_info_ratelimited("%s fuse_copy_args failed\n", __func__);
>>>> +               return err;
>>>> +       }
>>>> +
>>>> +       ent_in_out.payload_sz = cs.ring.copied_sz;
>>>> +       res = copy_to_user(&ent->headers->ring_ent_in_out, &ent_in_out,
>>>> +                          sizeof(ent_in_out));
>>>> +       err = res > 0 ? -EFAULT : res;
>>>> +       if (err)
>>>> +               return err;
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +static int
>>>> +fuse_uring_prepare_send(struct fuse_ring_ent *ring_ent)
>>>> +{
>>>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>>>> +       struct fuse_ring *ring = queue->ring;
>>>> +       struct fuse_req *req = ring_ent->fuse_req;
>>>> +       int err, res;
>>>> +
>>>> +       err = -EIO;
>>>> +       if (WARN_ON(ring_ent->state != FRRS_FUSE_REQ)) {
>>>> +               pr_err("qid=%d ring-req=%p invalid state %d on send\n",
>>>> +                      queue->qid, ring_ent, ring_ent->state);
>>>> +               err = -EIO;
>>>> +               goto err;
>>>> +       }
>>>> +
>>>> +       /* copy the request */
>>>> +       err = fuse_uring_copy_to_ring(ring, req, ring_ent);
>>>> +       if (unlikely(err)) {
>>>> +               pr_info_ratelimited("Copy to ring failed: %d\n", err);
>>>> +               goto err;
>>>> +       }
>>>> +
>>>> +       /* copy fuse_in_header */
>>>> +       res = copy_to_user(&ring_ent->headers->in_out, &req->in.h,
>>>> +                          sizeof(req->in.h));
>>>> +       err = res > 0 ? -EFAULT : res;
>>>> +       if (err)
>>>> +               goto err;
>>>> +
>>>> +       set_bit(FR_SENT, &req->flags);
>>>> +       return 0;
>>>> +
>>>> +err:
>>>> +       fuse_uring_req_end(ring_ent, true, err);
>>>> +       return err;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Write data to the ring buffer and send the request to userspace,
>>>> + * userspace will read it
>>>> + * This is comparable with classical read(/dev/fuse)
>>>> + */
>>>> +static int fuse_uring_send_next_to_ring(struct fuse_ring_ent *ring_ent,
>>>> +                                       unsigned int issue_flags)
>>>> +{
>>>> +       int err = 0;
>>>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>>>> +
>>>> +       err = fuse_uring_prepare_send(ring_ent);
>>>> +       if (err)
>>>> +               goto err;
>>>> +
>>>> +       spin_lock(&queue->lock);
>>>> +       ring_ent->state = FRRS_USERSPACE;
>>>> +       list_move(&ring_ent->list, &queue->ent_in_userspace);
>>>> +       spin_unlock(&queue->lock);
>>>> +
>>>> +       io_uring_cmd_done(ring_ent->cmd, 0, 0, issue_flags);
>>>> +       ring_ent->cmd = NULL;
>>>> +       return 0;
>>>> +
>>>> +err:
>>>> +       return err;
>>>> +}
>>>> +
>>>>  /*
>>>>   * Make a ring entry available for fuse_req assignment
>>>>   */
>>>> @@ -138,6 +376,210 @@ static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
>>>>         ring_ent->state = FRRS_AVAILABLE;
>>>>  }
>>>>
>>>> +/* Used to find the request on SQE commit */
>>>> +static void fuse_uring_add_to_pq(struct fuse_ring_ent *ring_ent,
>>>> +                                struct fuse_req *req)
>>>> +{
>>>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>>>> +       struct fuse_pqueue *fpq = &queue->fpq;
>>>> +       unsigned int hash;
>>>> +
>>>> +       /* commit_id is the unique id of the request */
>>>> +       ring_ent->commit_id = req->in.h.unique;
>>>> +
>>>> +       req->ring_entry = ring_ent;
>>>> +       hash = fuse_req_hash(ring_ent->commit_id);
>>>> +       list_move_tail(&req->list, &fpq->processing[hash]);
>>>> +}
>>>> +
>>>> +/*
>>>> + * Assign a fuse queue entry to the given entry
>>>> + */
>>>> +static void fuse_uring_add_req_to_ring_ent(struct fuse_ring_ent *ring_ent,
>>>> +                                          struct fuse_req *req)
>>>> +{
>>>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>>>> +
>>>> +       lockdep_assert_held(&queue->lock);
>>>> +
>>>> +       if (WARN_ON_ONCE(ring_ent->state != FRRS_AVAILABLE &&
>>>> +                        ring_ent->state != FRRS_COMMIT)) {
>>>> +               pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
>>>> +                       ring_ent->state);
>>>> +       }
>>>> +       list_del_init(&req->list);
>>>> +       clear_bit(FR_PENDING, &req->flags);
>>>> +       ring_ent->fuse_req = req;
>>>> +       ring_ent->state = FRRS_FUSE_REQ;
>>>> +       list_move(&ring_ent->list, &queue->ent_w_req_queue);
>>>> +       fuse_uring_add_to_pq(ring_ent, req);
>>>> +}
>>>> +
>>>> +/*
>>>> + * Release the ring entry and fetch the next fuse request if available
>>>> + *
>>>> + * @return true if a new request has been fetched
>>>> + */
>>>> +static bool fuse_uring_ent_assign_req(struct fuse_ring_ent *ring_ent)
>>>> +       __must_hold(&queue->lock)
>>>> +{
>>>> +       struct fuse_req *req;
>>>> +       struct fuse_ring_queue *queue = ring_ent->queue;
>>>> +       struct list_head *req_queue = &queue->fuse_req_queue;
>>>> +
>>>> +       lockdep_assert_held(&queue->lock);
>>>> +
>>>> +       /* get and assign the next entry while it is still holding the lock */
>>>> +       req = list_first_entry_or_null(req_queue, struct fuse_req, list);
>>>> +       if (req) {
>>>> +               fuse_uring_add_req_to_ring_ent(ring_ent, req);
>>>> +               return true;
>>>> +       }
>>>> +
>>>> +       return false;
>>>> +}
>>>> +
>>>> +/*
>>>> + * Read data from the ring buffer, which user space has written to
>>>> + * This is comparible with handling of classical write(/dev/fuse).
>>>> + * Also make the ring request available again for new fuse requests.
>>>> + */
>>>> +static void fuse_uring_commit(struct fuse_ring_ent *ring_ent,
>>>> +                             unsigned int issue_flags)
>>>> +{
>>>> +       struct fuse_ring *ring = ring_ent->queue->ring;
>>>> +       struct fuse_conn *fc = ring->fc;
>>>> +       struct fuse_req *req = ring_ent->fuse_req;
>>>> +       ssize_t err = 0;
>>>> +       bool set_err = false;
>>>> +
>>>> +       err = copy_from_user(&req->out.h, &ring_ent->headers->in_out,
>>>> +                            sizeof(req->out.h));
>>>> +       if (err) {
>>>> +               req->out.h.error = err;
>>>> +               goto out;
>>>> +       }
>>>> +
>>>> +       err = fuse_uring_out_header_has_err(&req->out.h, req, fc);
>>>> +       if (err) {
>>>> +               /* req->out.h.error already set */
>>>> +               goto out;
>>>> +       }
>>>> +
>>>> +       err = fuse_uring_copy_from_ring(ring, req, ring_ent);
>>>> +       if (err)
>>>> +               set_err = true;
>>>> +
>>>> +out:
>>>> +       fuse_uring_req_end(ring_ent, set_err, err);
>>>> +}
>>>> +
>>>> +/*
>>>> + * Get the next fuse req and send it
>>>> + */
>>>> +static void fuse_uring_next_fuse_req(struct fuse_ring_ent *ring_ent,
>>>> +                                    struct fuse_ring_queue *queue,
>>>> +                                    unsigned int issue_flags)
>>>> +{
>>>> +       int err;
>>>> +       bool has_next;
>>>> +
>>>> +retry:
>>>> +       spin_lock(&queue->lock);
>>>> +       fuse_uring_ent_avail(ring_ent, queue);
>>>> +       has_next = fuse_uring_ent_assign_req(ring_ent);
>>>> +       spin_unlock(&queue->lock);
>>>> +
>>>> +       if (has_next) {
>>>> +               err = fuse_uring_send_next_to_ring(ring_ent, issue_flags);
>>>> +               if (err)
>>>> +                       goto retry;
>>>> +       }
>>>> +}
>>>> +
>>>> +static int fuse_ring_ent_set_commit(struct fuse_ring_ent *ent)
>>>> +{
>>>> +       struct fuse_ring_queue *queue = ent->queue;
>>>> +
>>>> +       lockdep_assert_held(&queue->lock);
>>>> +
>>>> +       if (WARN_ON_ONCE(ent->state != FRRS_USERSPACE))
>>>> +               return -EIO;
>>>> +
>>>> +       ent->state = FRRS_COMMIT;
>>>> +       list_move(&ent->list, &queue->ent_commit_queue);
>>>> +
>>>> +       return 0;
>>>> +}
>>>> +
>>>> +/* FUSE_URING_CMD_COMMIT_AND_FETCH handler */
>>>> +static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_flags,
>>>> +                                  struct fuse_conn *fc)
>>>> +{
>>>> +       const struct fuse_uring_cmd_req *cmd_req = io_uring_sqe_cmd(cmd->sqe);
>>>> +       struct fuse_ring_ent *ring_ent;
>>>> +       int err;
>>>> +       struct fuse_ring *ring = fc->ring;
>>>> +       struct fuse_ring_queue *queue;
>>>> +       uint64_t commit_id = READ_ONCE(cmd_req->commit_id);
>>>> +       unsigned int qid = READ_ONCE(cmd_req->qid);
>>>> +       struct fuse_pqueue *fpq;
>>>> +       struct fuse_req *req;
>>>> +
>>>> +       err = -ENOTCONN;
>>>> +       if (!ring)
>>>> +               return err;
>>>> +
>>>> +       if (qid >= ring->nr_queues)
>>>> +               return -EINVAL;
>>>> +
>>>> +       queue = ring->queues[qid];
>>>> +       if (!queue)
>>>> +               return err;
>>>> +       fpq = &queue->fpq;
>>>> +
>>>> +       spin_lock(&queue->lock);
>>>> +       /* Find a request based on the unique ID of the fuse request
>>>> +        * This should get revised, as it needs a hash calculation and list
>>>> +        * search. And full struct fuse_pqueue is needed (memory overhead).
>>>> +        * As well as the link from req to ring_ent.
>>>> +        */
>>>
>>> imo, the hash calculation and list search seems ok. I can't think of a
>>> more optimal way of doing it. Instead of using the full struct
>>> fuse_pqueue, I think we could just have the "struct list_head
>>> *processing" defined inside "struct fuse_ring_queue" and change
>>> fuse_request_find() to take in a list_head. I don't think we need a
>>> dedicated spinlock for the list either. We can just reuse queue->lock,
>>> as that's (currently) always held already when the processing list is
>>> accessed.
>>
>>
>> Please see the attached patch, which uses xarray. Totally untested, though.
>> I actually found an issue while writing this patch - FR_PENDING was cleared
>> without holding fiq->lock, but that is important for request_wait_answer().
>> If something removes req from the list, we entirely loose the ring entry -
>> can never be used anymore. Personally I think the attached patch is safer.
>>
>>
>>>
>>>
>>>> +       req = fuse_request_find(fpq, commit_id);
>>>> +       err = -ENOENT;
>>>> +       if (!req) {
>>>> +               pr_info("qid=%d commit_id %llu not found\n", queue->qid,
>>>> +                       commit_id);
>>>> +               spin_unlock(&queue->lock);
>>>> +               return err;
>>>> +       }
>>>> +       list_del_init(&req->list);
>>>> +       ring_ent = req->ring_entry;
>>>> +       req->ring_entry = NULL;
>>>
>>> Do we need to set this to NULL, given that the request will be cleaned
>>> up later in fuse_uring_req_end() anyways?
>>
>> It is not explicitly set to NULL in that function. Would you mind to keep
>> it safe?
>>
>>>
>>>> +
>>>> +       err = fuse_ring_ent_set_commit(ring_ent);
>>>> +       if (err != 0) {
>>>> +               pr_info_ratelimited("qid=%d commit_id %llu state %d",
>>>> +                                   queue->qid, commit_id, ring_ent->state);
>>>> +               spin_unlock(&queue->lock);
>>>> +               return err;
>>>> +       }
>>>> +
>>>> +       ring_ent->cmd = cmd;
>>>> +       spin_unlock(&queue->lock);
>>>> +
>>>> +       /* without the queue lock, as other locks are taken */
>>>> +       fuse_uring_commit(ring_ent, issue_flags);
>>>> +
>>>> +       /*
>>>> +        * Fetching the next request is absolutely required as queued
>>>> +        * fuse requests would otherwise not get processed - committing
>>>> +        * and fetching is done in one step vs legacy fuse, which has separated
>>>> +        * read (fetch request) and write (commit result).
>>>> +        */
>>>> +       fuse_uring_next_fuse_req(ring_ent, queue, issue_flags);
>>>
>>> If there's no request ready to read next, then no request will be
>>> fetched and this will return. However, as I understand it, once the
>>> uring is registered, userspace should only be interacting with the
>>> uring via FUSE_IO_URING_CMD_COMMIT_AND_FETCH. However for the case
>>> where no request was ready to read, it seems like userspace would have
>>> nothing to commit when it wants to fetch the next request?
>>
>> We have
>>
>> FUSE_IO_URING_CMD_REGISTER
>> FUSE_IO_URING_CMD_COMMIT_AND_FETCH
>>
>>
>> After _CMD_REGISTER the corresponding ring-entry is ready to get fuse
>> requests and waiting. After it gets a request assigned and handles it
>> by fuse server the _COMMIT_AND_FETCH scheme applies. Did you possibly
>> miss that _CMD_REGISTER will already have it waiting?
>>
> 
> Sorry for the late reply. After _CMD_REGISTER and _COMMIT_AND_FETCH,
> it seems possible that there is no fuse request waiting until a later
> time? This is the scenario I'm envisioning:
> a) uring registers successfully and fetches request through _CMD_REGISTER
> b) server replies to request and fetches new request through _COMMIT_AND_FETCH
> c) server replies to request, tries to fetch new request but no
> request is ready, through _COMMIT_AND_FETCH
> 
> maybe I'm missing something in my reading of the code, but how will
> the server then fetch the next request once the request is ready? It
> will have to commit something in order to fetch it since there's only
> _COMMIT_AND_FETCH which requires a commit, no?
> 

The right name would be '_COMMIT_AND_FETCH_OR_WAIT'. Please see
fuse_uring_next_fuse_req().

retry:
	spin_lock(&queue->lock);
	fuse_uring_ent_avail(ent, queue);   	    --> entry available
	has_next = fuse_uring_ent_assign_req(ent);
	spin_unlock(&queue->lock);

	if (has_next) {
		err = fuse_uring_send_next_to_ring(ent, issue_flags);
		if (err)
			goto retry;
	}


If there is no available request, the io-uring cmd stored in ent->cmd is
just queued/available.

Btw, Miklos added it to linux-next.


Cheers,
Bernd


