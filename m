Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3F3218EBB7
	for <lists+io-uring@lfdr.de>; Sun, 22 Mar 2020 19:55:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726082AbgCVSzJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 22 Mar 2020 14:55:09 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:36324 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725881AbgCVSzJ (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 22 Mar 2020 14:55:09 -0400
Received: by mail-wm1-f65.google.com with SMTP id g62so12201953wme.1
        for <io-uring@vger.kernel.org>; Sun, 22 Mar 2020 11:55:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to;
        bh=Vviy09BidsojbTeYjk+vOhWhQ1saI09gPxNNQIHAzbg=;
        b=YocxE3ebR3t2PEGMqPjkTUjMr+2bQ/OktmL38bS0meGp7MNZBrEOIz5B6Gut5ygpRJ
         UrOq67u/Mri95FD6rr2sCBCESWoogFB9V75WvnrBQOI2o1zDYbwGmpqp5r3ZF5VqjErW
         aExl/nGSLt0U8P4i3fj6a67I3YnadAgTe3nYJnqMvOzqwe95feSX/yDpP5daNp/yx9yy
         wNJWksEt6BJkGNkHlUVIDLXASCtteJF4vPnc4W76DLQWs7JDFtePYQgxGqu5xOJzL5CP
         CVZiAKc422UN86CNX1KMBqEiz6XTq9HqnRI/tlx3hnUg5pekjnLIIlnMBJ7r/AuktfQe
         XA9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to;
        bh=Vviy09BidsojbTeYjk+vOhWhQ1saI09gPxNNQIHAzbg=;
        b=U6Un1KATK7anlSqJEnPErSx8m6W7Q1d1kIJKC8nUDMZGCcX/fczaR/mw6UvU5BJ6fa
         xTAFljeMx0sajDN+D9T4msPICsnzY4dUz7Fg7P2e4Ml10z9LklGZQg6uNhpHYlMJLTpn
         wPFy0B4a1YCHkdcOJptesEIFOXnRtkkxAWGMxokeDKflsC22WlgCS8ZPTuFSMq+XftJN
         Wq3nu8V1HjGq8eV8sS5ccC8W4DggGnpLMR4+WcoGlz2+V/CA6jZQw3+zUEHjwVrhQhiY
         xXTPwIIlPSZbSiOra/MtgPA0lgCkJMCLU1VvurNQnmEcnttYdmkYUOGug39NgsWqkeaI
         qOKg==
X-Gm-Message-State: ANhLgQ3YBhGb63rjOd8KcB0ySMIetWetN3qgVO9J0VZCbNIABSWoJkb+
        BWbhuuh892vpFopxk2InPghrKJp0
X-Google-Smtp-Source: ADFU+vs2CtwSN01ZRUT+W4e8Xf56JV2UgYNUFl7xGuySAdUHCsqsK+noAek0jmRsUOxlI4F+X0jIHg==
X-Received: by 2002:a1c:6043:: with SMTP id u64mr21899812wmb.115.1584903305540;
        Sun, 22 Mar 2020 11:55:05 -0700 (PDT)
Received: from [192.168.43.250] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id d13sm10058318wrv.34.2020.03.22.11.55.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 11:55:04 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
Message-ID: <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
Date:   Sun, 22 Mar 2020 21:54:07 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="gFyCLyNaz1bLn89DgYGlQVwwvRdi6zOKx"
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--gFyCLyNaz1bLn89DgYGlQVwwvRdi6zOKx
Content-Type: multipart/mixed; boundary="hQyyFkjO9aebVtqbj2pDKYSZsKDR80RPJ";
 protected-headers="v1"
From: Pavel Begunkov <asml.silence@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, io-uring <io-uring@vger.kernel.org>
Message-ID: <aa7049a8-179b-7c99-fce3-ac32b3500d31@gmail.com>
Subject: Re: [PATCH v2] io-wq: handle hashed writes in chains
References: <ab2e967f-754f-6dcf-95a0-4f24c47a9d5e@kernel.dk>
 <3454f8c1-3d5a-1f94-569a-41e553fc836a@gmail.com>
 <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>
In-Reply-To: <cd8541df-8f97-af3c-ea49-422e546ab648@gmail.com>

--hQyyFkjO9aebVtqbj2pDKYSZsKDR80RPJ
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

On 22/03/2020 19:24, Pavel Begunkov wrote:
> On 22/03/2020 19:09, Pavel Begunkov wrote:
>> On 19/03/2020 21:56, Jens Axboe wrote:
>>> We always punt async buffered writes to an io-wq helper, as the core
>>> kernel does not have IOCB_NOWAIT support for that. Most buffered asyn=
c
>>> writes complete very quickly, as it's just a copy operation. This mea=
ns
>>> that doing multiple locking roundtrips on the shared wqe lock for eac=
h
>>> buffered write is wasteful. Additionally, buffered writes are hashed
>>> work items, which means that any buffered write to a given file is
>>> serialized.
>>>
>>> When looking for a new work item, build a chain of identicaly hashed
>>> work items, and then hand back that batch. Until the batch is done, t=
he
>>> caller doesn't have to synchronize with the wqe or worker locks again=
=2E
>=20
> I have an idea, how to do it a bit better. Let me try it.

The diff below is buggy (Ooopses somewhere in blk-mq for
read-write.c:read_poll_link), I'll double check it on a fresh head.

The idea is to keep same-hashed works continuously in @work_list, so they=

can be spliced in one go. For each hash bucket, I keep last added work
- on enqueue, it adds a work after the last one
- on dequeue it splices [first, last]. Where @first is the current one, b=
ecause
of how we traverse @work_list.

It throws a bit of extra memory, but
- removes extra looping
- and also takes all hashed requests, but not only sequentially submitted=


e.g. for the following submission sequence, it will take all (hash=3D0) r=
equests.
REQ(hash=3D0)
REQ(hash=3D1)
REQ(hash=3D0)
REQ()
REQ(hash=3D0)
=2E..


Please, tell if you see a hole in the concept. And as said, there is stil=
l a bug
somewhere.

---
 fs/io-wq.c | 49 +++++++++++++++++++++++++++++++++++++++++++------
 fs/io-wq.h | 34 +++++++++++++++++++++++++++-------
 2 files changed, 70 insertions(+), 13 deletions(-)

diff --git a/fs/io-wq.c b/fs/io-wq.c
index b3fb61ec0870..00d8f8b12df3 100644
--- a/fs/io-wq.c
+++ b/fs/io-wq.c
@@ -69,6 +69,8 @@ struct io_worker {
 #define IO_WQ_HASH_ORDER	5
 #endif

+#define IO_WQ_HASH_NR_BUCKETS	(1u << IO_WQ_HASH_ORDER)
+
 struct io_wqe_acct {
 	unsigned nr_workers;
 	unsigned max_workers;
@@ -98,6 +100,7 @@ struct io_wqe {
 	struct list_head all_list;

 	struct io_wq *wq;
+	struct io_wq_work *last_hashed[IO_WQ_HASH_NR_BUCKETS];
 };

 /*
@@ -400,7 +403,9 @@ static struct io_wq_work *io_get_next_work(struct io_=
wqe *wqe)
 		hash =3D io_get_work_hash(work);
 		if (!(wqe->hash_map & BIT(hash))) {
 			wqe->hash_map |=3D BIT(hash);
-			wq_node_del(&wqe->work_list, node, prev);
+			wq_del_node_range(&wqe->work_list,
+					  &wqe->last_hashed[hash]->list, prev);
+			wqe->last_hashed[hash] =3D NULL;
 			return work;
 		}
 	}
@@ -508,7 +513,11 @@ static void io_worker_handle_work(struct io_worker *=
worker)

 		/* handle a whole dependent link */
 		do {
-			struct io_wq_work *old_work;
+			struct io_wq_work *old_work, *next_hashed =3D NULL;
+
+			if (work->list.next)
+				next_hashed =3D container_of(work->list.next,
+						       struct io_wq_work, list);

 			io_impersonate_work(worker, work);
 			/*
@@ -523,12 +532,20 @@ static void io_worker_handle_work(struct io_worker =
*worker)
 			work->func(&work);
 			work =3D (old_work =3D=3D work) ? NULL : work;

-			assign_work =3D work;
-			if (work && io_wq_is_hashed(work))
-				assign_work =3D NULL;
+			assign_work =3D next_hashed;
+			if (!next_hashed && work && !io_wq_is_hashed(work))
+				assign_work =3D work;
+
 			io_assign_current_work(worker, assign_work);
 			wq->free_work(old_work);

+			if (next_hashed) {
+				if (work)
+					io_wqe_enqueue(wqe, work);
+				work =3D next_hashed;
+				continue;
+			}
+
 			if (work && !assign_work) {
 				io_wqe_enqueue(wqe, work);
 				work =3D NULL;
@@ -776,6 +793,26 @@ static void io_run_cancel(struct io_wq_work *work, s=
truct
io_wqe *wqe)
 	} while (work);
 }

+static void io_wqe_insert_work(struct io_wqe *wqe, struct io_wq_work *wo=
rk)
+{
+	int hash;
+	struct io_wq_work *last_hashed;
+
+	if (!io_wq_is_hashed(work)) {
+append:
+		wq_list_add_tail(&work->list, &wqe->work_list);
+		return;
+	}
+
+	hash =3D io_get_work_hash(work);
+	last_hashed =3D wqe->last_hashed[hash];
+	wqe->last_hashed[hash] =3D work;
+	if (!last_hashed)
+		goto append;
+
+	wq_list_add_after(&work->list, &last_hashed->list, &wqe->work_list);
+}
+
 static void io_wqe_enqueue(struct io_wqe *wqe, struct io_wq_work *work)
 {
 	struct io_wqe_acct *acct =3D io_work_get_acct(wqe, work);
@@ -795,7 +832,7 @@ static void io_wqe_enqueue(struct io_wqe *wqe, struct=

io_wq_work *work)

 	work_flags =3D work->flags;
 	spin_lock_irqsave(&wqe->lock, flags);
-	wq_list_add_tail(&work->list, &wqe->work_list);
+	io_wqe_insert_work(wqe, work);
 	wqe->flags &=3D ~IO_WQE_FLAG_STALLED;
 	spin_unlock_irqrestore(&wqe->lock, flags);

diff --git a/fs/io-wq.h b/fs/io-wq.h
index 298b21f4a4d2..10367b6238da 100644
--- a/fs/io-wq.h
+++ b/fs/io-wq.h
@@ -40,17 +40,37 @@ static inline void wq_list_add_tail(struct io_wq_work=
_node
*node,
 	}
 }

+static inline void wq_list_add_after(struct io_wq_work_node *node,
+				    struct io_wq_work_node *pos,
+				    struct io_wq_work_list *list)
+{
+	struct io_wq_work_node *next =3D pos->next;
+
+	pos->next =3D node;
+	node->next =3D next;
+	if (!next)
+		list->last =3D node;
+}
+
+static inline void wq_del_node_range(struct io_wq_work_list *list,
+				     struct io_wq_work_node *last,
+				     struct io_wq_work_node *prev)
+{
+	if (!prev)
+		WRITE_ONCE(list->first, last->next);
+	else
+		prev->next =3D last->next;
+
+	if (last =3D=3D list->last)
+		list->last =3D prev;
+	last->next =3D NULL;
+}
+
 static inline void wq_node_del(struct io_wq_work_list *list,
 			       struct io_wq_work_node *node,
 			       struct io_wq_work_node *prev)
 {
-	if (node =3D=3D list->first)
-		WRITE_ONCE(list->first, node->next);
-	if (node =3D=3D list->last)
-		list->last =3D prev;
-	if (prev)
-		prev->next =3D node->next;
-	node->next =3D NULL;
+	wq_del_node_range(list, node, prev);
 }

 #define wq_list_for_each(pos, prv, head)			\
--=20
2.24.0


--hQyyFkjO9aebVtqbj2pDKYSZsKDR80RPJ--

--gFyCLyNaz1bLn89DgYGlQVwwvRdi6zOKx
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEE+6JuPTjTbx479o3OWt5b1Glr+6UFAl53tFQACgkQWt5b1Glr
+6XNHBAAnDjXYoAYlnOidf5cXwtcEyYYl0ECBuCU8YoegAAqsc9WY9W45/0cxL1s
y6k/GEW9F4iapkueH7K4pExY/ozdBmgjgWNbP17KvALhZkz3un169CzhBs8a6X94
i2U34xHeiJskIhzkZI+Aq50TquhxLXMARcj0t2ro4kn474IWwyokFmXYFNMEzqqS
CtJyP3awwi9/5ahSHN9PPVh54nH61eXqA00HXhy16f+Kqo36oYbNglEWih5xqAA/
ecMLFvtot+ya0YJnVg+F9C7V5cj0EfpTjRw8N5QByjen2xZQMp76FRioDxRJ8sVc
zMVNNJIAgbIitfHyqPRUf9n5TpHrM8kL/QiWOt4KsfecMrN0lplzbr6unQjjUdZw
3UAqYt9c5NqwheWr1W+uISZIcjcDEtr9pd8mpbEgpD5yY7FoAvaGrM8S6LYO75r/
DBOU2bAncHgP/3MG40baKA+VTcZsr7cdjcnGi4hLfyECzl+5ZkLw+FJmptpOqtD3
Fgn4DR/0mswmTR6uNIxBWkm7pjG4Dj3cGH0u/X83gW5cTaXo9sNoDG5prHBqszOu
QWNqsyZJWLRbDSioMMybQ/l4v8sOuKw+nJbvQgtLRt4GFHj/x7plESzYe76fFvdd
LLqjgziQ08PRyqhgfQ5g0AcZeecZr9aeDZPoHSdcye1GYIntFRc=
=Andd
-----END PGP SIGNATURE-----

--gFyCLyNaz1bLn89DgYGlQVwwvRdi6zOKx--
