Return-Path: <io-uring+bounces-12443-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id KEKkCgC0oGmHlwQAu9opvQ
	(envelope-from <io-uring+bounces-12443-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 21:58:40 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 99F641AF579
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 21:58:39 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 593323037C0B
	for <lists+io-uring@lfdr.de>; Thu, 26 Feb 2026 20:58:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4D93E330B2C;
	Thu, 26 Feb 2026 20:58:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="R1ZfUhdt"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2BFC374755
	for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 20:58:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772139517; cv=pass; b=P8dw4mUUNbV9wYxHtHQVFnuQ9pnlGz2adW78h2KYGnUgGRfaY8b8DR64q2j+LWMr4UA+w30jdlppeLimh+rHR4QYRz4+yiqX1HbrBLglRUYHk9xPDTciJJ4VI09Tekq8e8VRFCliTFfGz8dmfB0LANZJYe4Mndw7q1EXX8ExuXc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772139517; c=relaxed/simple;
	bh=NWUWldiilxuF+8zG4Qi2KDmU8aOi4ClpEE92pymF1Xg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dYtqc0M1S05YIXCOl+ihp8yXkG6WPh0ZCyAlDMyVBdo8UVu1AHjTdvtQM3JphWAkeEGpPJJwgRy2F3uLZz+B26t4VNfZah54r6CW+kz4BUIcpttvaS4Rk35bWnIIPt4NnCZPP1rmJDPBO5HhQJFS9QtMtX0mNjZyJsZtELoEK/A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=R1ZfUhdt; arc=pass smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-506a3400f30so11804841cf.1
        for <io-uring@vger.kernel.org>; Thu, 26 Feb 2026 12:58:33 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772139512; cv=none;
        d=google.com; s=arc-20240605;
        b=VGmCUHjLWs6NL2Q/seZ5WsO+59Wax7juQlN9lOv9oJ891j0vi0DZHpmvN7VWevHsr6
         EnBRgnE5BmQpG1RHnRc/zx8iU/xVEq5JG0xrdzxMTWWiJYrWModNJUO6ZD/aTTp+jq6Z
         4aPkxZ7yTKneWnu4AjlSAtSyKk10kB32LsuPwbCRvpZ7Bp0UeCwu4YHzXqnr8mThTCGu
         HmGKoldlMlTVhj1MbIf49hZdAuOOOJl6ZajLxzCGaGxu++7+5NPhTpwa5L3AZfvmzvs/
         Fhg5og20Y85OQHcLbNpM+dqFkEoWlO+nCarIhC5ivpzC2eSYCTAqYSRHBJhhpeJBYq5z
         XprA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gAoboHkEOLHq4doGSCyntORfVMKmjLAt0TfIfQYkQ0Y=;
        fh=OWpt+6TrQZSAv9H9EcLZ7tQ3j1cYkQU2s0QRUkFQaUA=;
        b=Ow3dqJBjHc2Q3khZF1rWWyt6d1bGa+RnDZdkl4ivApGQjdVRg3ITmAc1rv88mzgqGg
         Ab+Fih3vjbg+icu6ZAxq85xH/ma+C6J5aadaKAKYA232b/0c7NkShqY+jQEi/buB6lc2
         1OYw1m0L4pgXAdPbUvFfw+3kbrLT5+oGLlaZ2x9AmbBLHKyYLRJEBZCJcw1KGCQbgYM0
         9m31TD7xpwcpV26t49uIPDMjOxBp3sZJNGf+wdqwDoUY+Tp4fIu2iVxXOOkvrqSLdHle
         8NfaYb9exekM9UxOae1AFK59d2QdN5hYUCY440k5OGajc+0KgL2FE1UZUTgTAWGqXPAj
         2W5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772139512; x=1772744312; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gAoboHkEOLHq4doGSCyntORfVMKmjLAt0TfIfQYkQ0Y=;
        b=R1ZfUhdtIoc87fEeyjonxgKOe5bm47VG+SWbrQwU/R58FWECi7+inGZVTqsI9rCljl
         LdbIgfh4JJ3VBoVamthVpjsDR0hiOsBJARnErJtUyyYk3xeDSEXtmU76SlYHB3zIn52A
         XYLyom5wAtFqWqnz4qxYtGWfl7c/a5loNBoFECupBkZSTStl/u+FJRc8c8MwyNewXcma
         AtHTpwyZ7L3C0dJnkvRWeRmW+goaEM6tV8H5YFoTTAUciNMebVoFSzbLKfUDfSN6I9uU
         fMmU5bKXeMuSgNdnaDn+bYWYD/6yro/N1gyOf1Hy/j+t4/Zxlikb9TmRRFGIgk0AJDfe
         +5/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772139512; x=1772744312;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gAoboHkEOLHq4doGSCyntORfVMKmjLAt0TfIfQYkQ0Y=;
        b=VlVQV6QsNEepeopcEbKkvs3rWWciY1xPZTOE46T6xSkzjiGbzaJgCedGxdlKRoNFlY
         yGO3r8v958zkNznQZBr7k6qCxyXYLnZ0lt4q4IJ1JwnGSDU/RVtnKpEpw8Gtd1HRUhJz
         NnWkyUIguEE/vtUPhjIVRfyvcI6p2XzNeahk9kjPR5UnETgrWiTzIlAIX6QMHdyIfBgI
         R2T2SaofBy6XJd+9t8DOTPQpQyqJkxq6lSakl6UnHUz2I9MM6+1YldOeVYlqEaIDPpmk
         +7vQSQ8UcYgH7eEUuIZxGFI7F9rDqWHThS5jHSbJcThdwq8ET6cCUcirK6HMrYhPZ9CS
         pblA==
X-Forwarded-Encrypted: i=1; AJvYcCVPWTRHbpCzMYgSKXbvyvhqXxMOiHoCP6Nz5ofKQowD/L/gZZbmfmHT5bC2nGpb0AfbS5KXHMQlow==@vger.kernel.org
X-Gm-Message-State: AOJu0YzJyIps0i+6vqQf1lANOkKN2LZ1/eH81aADEcRWc3s3pgS3XQXB
	W9MFvvmNZgV4+Tt6HZiOIv4fWhDWJnf4gi1EuGy05JBbrRPErAqtRp/Nubzjdjca/4uC339bfAA
	DbIenrBswTl/rrnoQ2AZZMVp4poDTEz4=
X-Gm-Gg: ATEYQzzAQ0gL+V6iwAP3mEGm2Wv9J7QDwXVs/xoSvZn6KdwCM+nsybtQl0uuF/JF9J5
	LPKqDH5U3yzEwii8anTX3xZkd5NAadqI6EjcSrobI8CteHndAZ1eMpXXxdtZBVWdkySqt7gQbAD
	Zb3zWfxHjpVW70ksx2LBskBczA+Oc8SyXfBegd6oGIm5h2vhF72CShbjBBlzHjHK7/g7AZmTkKi
	fz4gnMrHXC99mZovcmGPDKmzzWoKZW0MC/JfBULoUgcG4HmvhcuINwla+pXcR+KI5ZskMTPIyGs
	ZObX2UM/AFbROZkP
X-Received: by 2002:a05:622a:40b:b0:501:3b85:272c with SMTP id
 d75a77b69052e-50752426793mr6058641cf.31.1772139512524; Thu, 26 Feb 2026
 12:58:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260116233044.1532965-1-joannelkoong@gmail.com>
 <20260116233044.1532965-20-joannelkoong@gmail.com> <2f14fb1a-0ee2-4d86-98be-ed6112ed706d@bsbernd.com>
 <7ccf7574-42d4-4094-9b84-eb223e73188e@bsbernd.com> <CAJnrk1b6z2oar_Zw89N275zfyU2+oZJwtozSdTPFw49x38FCOA@mail.gmail.com>
 <cb5bfa20-447d-4392-b7a5-8f7d49d70157@bsbernd.com>
In-Reply-To: <cb5bfa20-447d-4392-b7a5-8f7d49d70157@bsbernd.com>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Thu, 26 Feb 2026 12:58:20 -0800
X-Gm-Features: AaiRm525qDFeuVkDHV2O68NT6KdqlbW3rbzn7OGNFuy8Hu2zconwXj0MEDBTi-w
Message-ID: <CAJnrk1ZQC=tE8z+D1rSnNijkMhXDPEZaB_9WL9NPZyKmG2=NSQ@mail.gmail.com>
Subject: Re: [PATCH v4 19/25] fuse: add io-uring kernel-managed buffer ring
To: Bernd Schubert <bernd@bsbernd.com>
Cc: axboe@kernel.dk, miklos@szeredi.hu, csander@purestorage.com, 
	krisman@suse.de, io-uring@vger.kernel.org, asml.silence@gmail.com, 
	xiaobing.li@samsung.com, safinaskar@gmail.com, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[gmail.com,none];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[gmail.com:s=20230601];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-12443-lists,io-uring=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_CC(0.00)[kernel.dk,szeredi.hu,purestorage.com,suse.de,vger.kernel.org,gmail.com,samsung.com];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-0.999];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[joannelkoong@gmail.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[gmail.com:+];
	MID_RHS_MATCH_FROMTLD(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	RCPT_COUNT_SEVEN(0.00)[10];
	FREEMAIL_FROM(0.00)[gmail.com];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,bsbernd.com:email,mail.gmail.com:mid]
X-Rspamd-Queue-Id: 99F641AF579
X-Rspamd-Action: no action

On Thu, Feb 26, 2026 at 10:21=E2=80=AFAM Bernd Schubert <bernd@bsbernd.com>=
 wrote:
>
> On 2/26/26 00:42, Joanne Koong wrote:
> > On Wed, Feb 25, 2026 at 9:55=E2=80=AFAM Bernd Schubert <bernd@bsbernd.c=
om> wrote:
> >> On 1/28/26 22:44, Bernd Schubert wrote:
> >>> On 1/17/26 00:30, Joanne Koong wrote:
> >>>> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> >>>> @@ -940,6 +1188,7 @@ static int fuse_uring_commit_fetch(struct io_ur=
ing_cmd *cmd, int issue_flags,
> >>>>      unsigned int qid =3D READ_ONCE(cmd_req->qid);
> >>>>      struct fuse_pqueue *fpq;
> >>>>      struct fuse_req *req;
> >>>> +    bool send;
> >>>>
> >>>>      err =3D -ENOTCONN;
> >>>>      if (!ring)
> >>>> @@ -990,7 +1239,12 @@ static int fuse_uring_commit_fetch(struct io_u=
ring_cmd *cmd, int issue_flags,
> >>>>
> >>>>      /* without the queue lock, as other locks are taken */
> >>>>      fuse_uring_prepare_cancel(cmd, issue_flags, ent);
> >>>> -    fuse_uring_commit(ent, req, issue_flags);
> >>>> +
> >>>> +    err =3D fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
> >>>> +    if (err)
> >>>> +            fuse_uring_req_end(ent, req, err);
> >>>> +    else
> >>>> +            fuse_uring_commit(ent, req, issue_flags);
> >>>>
> >>>>      /*
> >>>>       * Fetching the next request is absolutely required as queued
> >>>> @@ -998,7 +1252,9 @@ static int fuse_uring_commit_fetch(struct io_ur=
ing_cmd *cmd, int issue_flags,
> >>>>       * and fetching is done in one step vs legacy fuse, which has s=
eparated
> >>>>       * read (fetch request) and write (commit result).
> >>>>       */
> >>>> -    if (fuse_uring_get_next_fuse_req(ent, queue))
> >>>> +    send =3D fuse_uring_get_next_fuse_req(ent, queue, issue_flags);
> >>>> +    fuse_uring_headers_cleanup(ent, issue_flags);
> >>>> +    if (send)
> >>>>              fuse_uring_send(ent, cmd, 0, issue_flags);
> >>>>      return 0;
> >>
> >>
> >> Hello Joanne,
> >>
> >> couldn't it call fuse_uring_headers_cleanup() before the
> >> fuse_uring_get_next_fuse_req()? I find it a bit confusing that it firs=
ts
> >> gets the next request and then cleans up the buffer from the previous
> >> request.
> >
> > Hi Bernd,
> >
> > Thanks for taking a look.
> >
> > The fuse_uring_headers_cleanup() call has to happen after the
> > fuse_uring_get_next_fuse_req() call because
> > fuse_uring_get_next_fuse_req() copies payload to the header, so we
> > can't yet relinquish the refcount on the headers buffer / clean it up
> > yet. I can add a comment about this to make this more clear.
>
> I only found time right now and already super late (or early) here.
>
> I guess that is fuse_uring_copy_to_ring -> copy_header_to_ring, but why
> can it then call fuse_uring_headers_cleanup() ->
> io_uring_fixed_index_put(). I.e. doesn't it put buffer it just copied
> to? Why not the sequence of
>
> err =3D fuse_uring_headers_prep(ent, ITER_SOURCE, issue_flags);
> fuse_uring_commit(ent, req, issue_flags);
> fuse_uring_headers_cleanup(ent, issue_flags);
>
> And then fuse_uring_get_next_fuse_req() does another
> fuse_uring_headers_prep() with ITER_DEST?

The headers buffer is the same buffer for the request that's being
committed and the next request that is fetched (just like how the ent
is the same ent for the request that's committed and the next fetched
request). Because of this we can just reuse the same headers_iter and
call io_uring_fixed_index_put() after we're done copying over the next
request. I can add a comment about this to make this more clear.

>
>
> >
> >>
> >> As I understand it, the the patch basically adds the feature of 0-byte
> >> payloads. Maybe worth mentioning in the commit message?
> >
> > Hmm I'm not really sure I am seeing where the 0-byte payload gets
> > added. On the server side, they don't receive payloads that are
> > 0-bytes. If there is no next fuse request to send, then nothing gets
> > sent. But maybe I'm not interpreting your comment about 0-byte
> > payloads correctly?
>
> There is fuse_uring_req_has_payload() and
> fuse_uring_select_buffer()/fuse_uring_next_req_update_buffer() using
> that function. When a request doesn't have a payload the ring entries
> runs without a payload - effectively that introduces 0-byte payloads,
> doesn't it?

When the request doesn't have a payload, no ring entry gets used for
the request. The check for this happens in fuse_uring_prep_buffer()

static int fuse_uring_prep_buffer(struct fuse_ring_ent *ent,
                                  struct fuse_req *req, unsigned issue_flag=
s)
{
        ...
        /* no payload to copy, can skip selecting a buffer */
        if (!fuse_uring_req_has_payload(req))
                return 0;

        return fuse_uring_select_buffer(ent, issue_flags);
}

>
> >
> >> I also wonder if it would be worth to document as code comment that
> >> fuse_uring_ent_assign_req / fuse_uring_next_req_update_buffer are
> >> allowed to fail for a buffer upgrade (i.e. 0 to max-payload). At least
> >
> > Good idea, I'll add a comment about this.
> >
> >> the current comment of  "Fetching the next request is absolutely
> >> required" is actually not entirely true anymore.
> >>
> >
> > I don't think this patch introduces new behavior on this front.
> > fuse_uring_get_next_fuse_req() is still called to fetch the next
> > request AFAICS.
> >
>
> It still does, but if the request didn't have a payload it might not
> have a buffer and if it didn't have a buffer and doesn't manage to get a
> buffer, it doesn't handle a request - that a bit change of
> 'commit-and-fetch always fetches a new request if there is any request
> queued'.

Ok, I'll update the "Fetching the next request is absolutely required" comm=
ent.

Thanks,
Joanne
>
>
> Thanks,
> Bernd

