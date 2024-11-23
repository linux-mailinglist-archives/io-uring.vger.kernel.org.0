Return-Path: <io-uring+bounces-5002-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id D0B699D6883
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 10:52:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 95D91281C7D
	for <lists+io-uring@lfdr.de>; Sat, 23 Nov 2024 09:52:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E2617084F;
	Sat, 23 Nov 2024 09:52:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b="OnQMoOIZ"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 614B116FF44
	for <io-uring@vger.kernel.org>; Sat, 23 Nov 2024 09:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732355556; cv=none; b=bNrQlwIK4eUebeIAjfvhJBnqBCAl5C9rNHIJ/HMf1Ujxyy+5hYqS/5uaF0MEh8IXNxbFgxIRNt2rxwY40ZzeXyHGTf5uFRmBsKDmEBIanyF6b1Vqd0Hzn7eiLU6hLrCSOQGdXJ89BR7FbRmkUkc8Cd9SwEBy3WKro1BAx2XpO7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732355556; c=relaxed/simple;
	bh=JsftFFy6Awj8SNiG5+p8xm/w1vLK2OFmElvQj1EPZDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=faXgRVvm1eWAZ+379z04D65GVLNlK8uTvuDS8MeeXZsgG1cOLe68FgYZQKM+p++7FB6MqNPvVz12bzE9fHM+1sd5v3TtZsdARvMWzKR898sORFd7XSJw4qv4F8beOd5398RDUoZLHEa82/smiP9eQNAsLF2M4GFwlSg1RHEdMqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu; spf=pass smtp.mailfrom=szeredi.hu; dkim=pass (1024-bit key) header.d=szeredi.hu header.i=@szeredi.hu header.b=OnQMoOIZ; arc=none smtp.client-ip=209.85.160.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=szeredi.hu
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=szeredi.hu
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-460ad98b031so20078861cf.0
        for <io-uring@vger.kernel.org>; Sat, 23 Nov 2024 01:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1732355553; x=1732960353; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pfuwWH6s9WheFli8owZJ40a4CslfDCyeDxz9fgZYQFc=;
        b=OnQMoOIZPhy9Oe5gBN2IQLsRXHRH/UE0GNhI8ojzoR9qNeH5JIWqaOQ0HK6aU3WmDw
         N6iw8R6uLj61Le34SykIYG0f02/UbBPejKEWwSwrfP8vBJ2+863qwmDAYhIBL0WE5BPz
         BQMK/DRwCujqHTf4IWuHJfmWXiEWAn0/CbD1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732355553; x=1732960353;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pfuwWH6s9WheFli8owZJ40a4CslfDCyeDxz9fgZYQFc=;
        b=JGo7S8dFcrS1sJoRshxZdF/S8iPQSILyTx9WRN7e0MM3PRaDPNt7F1xh0NMQtjCeqa
         ZEsZfx726hFWtqaU4M4h2h3q1MbA6rZCXBnfT3/7XrHaHJBuo7pM09X5hFnR8/qXa5QF
         3sONW3RZCsC8C7Sh00FcBYbCGOlTK5OQGPqxdvn7oWgTYJeCWIFu4jRDNnnqsePYOnda
         6Q+2mdKIsUpreYrjMPTAnsI6G6Et78811RkxPVJqBkV5FYG68cT/HkhViZVt15edeGYa
         gXxZxAtj31pwSZyjJWQHUQNiMgFGTEeVciolq/5PmrJqHmsIs9iWl79JK04YDrBE17G9
         Zu8w==
X-Forwarded-Encrypted: i=1; AJvYcCWVOR++vzClF8xDoj2omYgn3i0eP4VboqKRy5zgZ+C9kNoJqpVbIsd3R5HjOvk2Ss7qta260HmqXA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yym7YNOxG7DZ8pJiLPsbYpbv1QYA32BCJllgVc/cZmV5jaNFCp5
	kXWsEK3ZY1yeV3pd0JsOuKJ/fPeoMrGWBgfmc/VWtbZyaSGhiiIt4rOWIz/3jFnDdq4AH2GuNpU
	JUFp60qHX9Q2gE1uIbyctQVLrOTqiMgBZYTBP4g==
X-Gm-Gg: ASbGnctbOhKE0wxIMQ7EKPQuD0Tr1UmdFO7NFyHyXCmYN9p51YMxrFUb5PyldN89qdT
	72tVYSfLthgP8+ezYNWfOJli/+U7ZljEi/g==
X-Google-Smtp-Source: AGHT+IE7Cdtq1dglVEIsBM11JPHkABoLeUdp8yGp5PTxuThy3hmuvowcYbrEvtHDUYqVfRNXdhwHQW32MvJkS4f6z7s=
X-Received: by 2002:a05:622a:452:b0:461:333a:46c with SMTP id
 d75a77b69052e-4653d5a4927mr79042581cf.27.1732355553365; Sat, 23 Nov 2024
 01:52:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241122-fuse-uring-for-6-10-rfc4-v6-0-28e6cdd0e914@ddn.com> <20241122-fuse-uring-for-6-10-rfc4-v6-6-28e6cdd0e914@ddn.com>
In-Reply-To: <20241122-fuse-uring-for-6-10-rfc4-v6-6-28e6cdd0e914@ddn.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Sat, 23 Nov 2024 10:52:22 +0100
Message-ID: <CAJfpegtih77CpuSQAOkUaKRMPj44ua65+_MUMa3LqgYjLFofqg@mail.gmail.com>
Subject: Re: [PATCH RFC v6 06/16] fuse: {uring} Handle SQEs - register commands
To: Bernd Schubert <bschubert@ddn.com>
Cc: Jens Axboe <axboe@kernel.dk>, Pavel Begunkov <asml.silence@gmail.com>, 
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org, 
	Joanne Koong <joannelkoong@gmail.com>, Josef Bacik <josef@toxicpanda.com>, 
	Amir Goldstein <amir73il@gmail.com>, Ming Lei <tom.leiming@gmail.com>, David Wei <dw@davidwei.uk>, 
	bernd@bsbernd.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 22 Nov 2024 at 00:44, Bernd Schubert <bschubert@ddn.com> wrote:

> +static struct fuse_ring *fuse_uring_create(struct fuse_conn *fc)
> +{
> +       struct fuse_ring *ring = NULL;
> +       size_t nr_queues = num_possible_cpus();
> +       struct fuse_ring *res = NULL;
> +
> +       ring = kzalloc(sizeof(*fc->ring) +
> +                              nr_queues * sizeof(struct fuse_ring_queue),

Left over from a previous version?

> +static void fuse_uring_ent_avail(struct fuse_ring_ent *ring_ent,
> +                                struct fuse_ring_queue *queue)
> +       __must_hold(&queue->lock)
> +{
> +       struct fuse_ring *ring = queue->ring;
> +
> +       lockdep_assert_held(&queue->lock);
> +
> +       /* unsets all previous flags - basically resets */
> +       pr_devel("%s ring=%p qid=%d state=%d\n", __func__, ring,
> +                ring_ent->queue->qid, ring_ent->state);
> +
> +       if (WARN_ON(ring_ent->state != FRRS_COMMIT)) {
> +               pr_warn("%s qid=%d state=%d\n", __func__, ring_ent->queue->qid,
> +                       ring_ent->state);
> +               return;
> +       }
> +
> +       list_move(&ring_ent->list, &queue->ent_avail_queue);
> +
> +       ring_ent->state = FRRS_WAIT;
> +}

AFAICS this function is essentially just one line, the rest is
debugging.   While it's good for initial development it's bad for
review because the of the bad signal to noise ratio (the debugging
part is irrelevant for code review).

Would it make sense to post the non-RFC version without most of the
pr_debug()/pr_warn() stuff and just keep the simple WARN_ON() lines
that signal if something has gone wrong.

Long term we could get rid of some of that too.   E.g ring_ent->state
seems to be there just for debugging, but if the code is clean enough
we don't need to have a separate state.

> +#if 0
> +       /* Does not work as sending over io-uring is async */
> +       err = -ETXTBSY;
> +       if (fc->initialized) {
> +               pr_info_ratelimited(
> +                       "Received FUSE_URING_REQ_FETCH after connection is initialized\n");
> +               return err;
> +       }
> +#endif

I fail to remember what's up with this.  Why is it important that
FETCH is sent before INIT reply?

> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 6c506f040d5fb57dae746880c657a95637ac50ce..e82cbf9c569af4f271ba0456cb49e0a5116bf36b 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -8,6 +8,7 @@
>
>  #include <linux/types.h>
>
> +

Unneeded extra line.

Thanks,
Miklos

