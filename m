Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A4625AB61D
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 18:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237506AbiIBQAf (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 12:00:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237826AbiIBQAM (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 12:00:12 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21B234B4B5;
        Fri,  2 Sep 2022 08:05:34 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id u3-20020a4ab5c3000000b0044b125e5d9eso405978ooo.12;
        Fri, 02 Sep 2022 08:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date;
        bh=m9v7oop8rTcU1E99FRL05uZUidYjHyiKvJlObLLnlsI=;
        b=oP/20gdMpaQ73qqaervtXrorePCXOnhfzYuW0DjvrKnRJbzzJsfrvXF/DaHDq1ElXt
         F3dL3jSk3pm7GqR1RIfUXkp+c41WV1EoIl1e5QZnU7Xx0BtZzjcgTxQ+1IkzPM04+ykk
         cTib3QxLAIyt1FY5oSLap0TUSqxTkwvlJP8TBaU8ssGuZnb+tLo2UgQRe1PL6nkMjpIb
         QFarm/AJYJN4FiISHPMWkcW7PLfn8L24QlEqpdAOVncrvTU/wnbocxv9YWkSXLieRyen
         YxUsZ65kOJG5C3Jptk6+zOUiqUHqAZE8ZTx/SaKagHWcsdippB6zwtnuX2jKIEbX4IoA
         yO8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=m9v7oop8rTcU1E99FRL05uZUidYjHyiKvJlObLLnlsI=;
        b=41AuSZC6jJvXGH/Fscy4RTN+rlM2A0aXW0Z1OBAAZLCKnQcQcH3U51PRBL+vE2I5ot
         rla+Yzl1e8gZ+CD9btJtwewFCWjAC3LMRATNDp2s/Fv08/fUCR0fDjL8IVOgdbyjKkig
         K7c//u0qYnDpgM7aRdufNPg0CF/buHj09jC9CeJ3O2nXUmliJ/SJ+aqXdmCkGhJ/0zxv
         IkCJw4Z8oX2ag+R9KD5dYsohc263f7GLMuCAt8MUFuOzSDxjHSuNe/KaRFxxNxpsAPsR
         SDU7V9S9q+0M16RkvOdrIA71U+/DOfakL8ppbZWkS3NCpvliWd0MQ39wWNm+1SLQnnbc
         DQEQ==
X-Gm-Message-State: ACgBeo2K9JGYQySXQTQdwnVqrhxrgOoWhCahgFtiCJPJBDVVjzvLIKPp
        mHiA0NmWcP1P+9tf111E7Fuv/nSHlLV4LyUj+dw=
X-Google-Smtp-Source: AA6agR7exQncoh9YeOpPhGSlB5sD9iV0VfLz8fguIbl/BQTHKwpQzgtYBQfzkCwqlHq8KkVbdLme2k1YAJ0wipkgJ8s=
X-Received: by 2002:a4a:5d44:0:b0:44e:2b42:316c with SMTP id
 w65-20020a4a5d44000000b0044e2b42316cmr4498715ooa.15.1662131133463; Fri, 02
 Sep 2022 08:05:33 -0700 (PDT)
MIME-Version: 1.0
References: <20220901225849.42898-1-shr@fb.com> <20220901225849.42898-2-shr@fb.com>
 <CAL3q7H7Xm+HkUXE6zeT+0fH+9Hi9XhE7gXH7mYcGeAoYR5D2XQ@mail.gmail.com> <d42ec471-b67f-6504-72bf-8bbc761ac3e7@kernel.dk>
In-Reply-To: <d42ec471-b67f-6504-72bf-8bbc761ac3e7@kernel.dk>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 2 Sep 2022 16:04:57 +0100
Message-ID: <CAL3q7H6GLm+hbcJP5Mc0mjyFcWX-8wGD9LVJeYUE6HmgoZK1Vg@mail.gmail.com>
Subject: Re: [PATCH v1 01/10] btrfs: implement a nowait option for tree searches
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Stefan Roesch <shr@fb.com>, kernel-team@fb.com,
        io-uring@vger.kernel.org, linux-btrfs@vger.kernel.org,
        josef@toxicpanda.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Fri, Sep 2, 2022 at 3:57 PM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/2/22 8:48 AM, Filipe Manana wrote:
> > On Fri, Sep 2, 2022 at 12:01 AM Stefan Roesch <shr@fb.com> wrote:
> >>
> >> From: Josef Bacik <josef@toxicpanda.com>
> >>
> >> For NOWAIT IOCB's we'll need a way to tell search to not wait on locks
> >> or anything.  Accomplish this by adding a path->nowait flag that will
> >> use trylocks and skip reading of metadata, returning -EWOULDBLOCK in
> >> either of these cases.  For now we only need this for reads, so only t=
he
> >> read side is handled.  Add an ASSERT() to catch anybody trying to use
> >> this for writes so they know they'll have to implement the write side.
> >>
> >> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> >> Signed-off-by: Stefan Roesch <shr@fb.com>
> >> ---
> >>  fs/btrfs/ctree.c   | 39 ++++++++++++++++++++++++++++++++++++---
> >>  fs/btrfs/ctree.h   |  1 +
> >>  fs/btrfs/locking.c | 23 +++++++++++++++++++++++
> >>  fs/btrfs/locking.h |  1 +
> >>  4 files changed, 61 insertions(+), 3 deletions(-)
> >>
> >> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> >> index ebfa35fe1c38..052c768b2297 100644
> >> --- a/fs/btrfs/ctree.c
> >> +++ b/fs/btrfs/ctree.c
> >> @@ -1447,6 +1447,11 @@ read_block_for_search(struct btrfs_root *root, =
struct btrfs_path *p,
> >>                         return 0;
> >>                 }
> >>
> >> +               if (p->nowait) {
> >> +                       free_extent_buffer(tmp);
> >> +                       return -EWOULDBLOCK;
> >> +               }
> >> +
> >>                 if (unlock_up)
> >>                         btrfs_unlock_up_safe(p, level + 1);
> >>
> >> @@ -1467,6 +1472,8 @@ read_block_for_search(struct btrfs_root *root, s=
truct btrfs_path *p,
> >>                         ret =3D -EAGAIN;
> >>
> >>                 goto out;
> >> +       } else if (p->nowait) {
> >> +               return -EWOULDBLOCK;
> >>         }
> >>
> >>         if (unlock_up) {
> >> @@ -1634,7 +1641,13 @@ static struct extent_buffer *btrfs_search_slot_=
get_root(struct btrfs_root *root,
> >>                  * We don't know the level of the root node until we a=
ctually
> >>                  * have it read locked
> >>                  */
> >> -               b =3D btrfs_read_lock_root_node(root);
> >> +               if (p->nowait) {
> >> +                       b =3D btrfs_try_read_lock_root_node(root);
> >> +                       if (IS_ERR(b))
> >> +                               return b;
> >> +               } else {
> >> +                       b =3D btrfs_read_lock_root_node(root);
> >> +               }
> >>                 level =3D btrfs_header_level(b);
> >>                 if (level > write_lock_level)
> >>                         goto out;
> >> @@ -1910,6 +1923,13 @@ int btrfs_search_slot(struct btrfs_trans_handle=
 *trans, struct btrfs_root *root,
> >>         WARN_ON(p->nodes[0] !=3D NULL);
> >>         BUG_ON(!cow && ins_len);
> >>
> >> +       /*
> >> +        * For now only allow nowait for read only operations.  There'=
s no
> >> +        * strict reason why we can't, we just only need it for reads =
so I'm
> >> +        * only implementing it for reads right now.
> >> +        */
> >> +       ASSERT(!p->nowait || !cow);
> >> +
> >>         if (ins_len < 0) {
> >>                 lowest_unlock =3D 2;
> >>
> >> @@ -1936,7 +1956,12 @@ int btrfs_search_slot(struct btrfs_trans_handle=
 *trans, struct btrfs_root *root,
> >>
> >>         if (p->need_commit_sem) {
> >>                 ASSERT(p->search_commit_root);
> >> -               down_read(&fs_info->commit_root_sem);
> >> +               if (p->nowait) {
> >> +                       if (!down_read_trylock(&fs_info->commit_root_s=
em))
> >> +                               return -EAGAIN;
> >
> > Why EAGAIN here and everywhere else EWOULDBLOCK? See below.
>
> Is EWOULDBLOCK ever different from EAGAIN? But it should be used
> consistently, EAGAIN would be the return of choice for that.

Oh right, EWOULDBLOCK is defined as EAGAIN, same values.
It would be best to use the same everywhere, avoiding confusion...

>
> --
> Jens Axboe



--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
