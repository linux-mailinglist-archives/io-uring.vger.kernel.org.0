Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E9ED75AB4D7
	for <lists+io-uring@lfdr.de>; Fri,  2 Sep 2022 17:16:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236302AbiIBPQg (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 2 Sep 2022 11:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236523AbiIBPQO (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 2 Sep 2022 11:16:14 -0400
Received: from mail-oa1-x34.google.com (mail-oa1-x34.google.com [IPv6:2001:4860:4864:20::34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9BED5208A;
        Fri,  2 Sep 2022 07:48:44 -0700 (PDT)
Received: by mail-oa1-x34.google.com with SMTP id 586e51a60fabf-11edd61a9edso5246192fac.5;
        Fri, 02 Sep 2022 07:48:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:from:to:cc:subject
         :date;
        bh=W+b+9jSnMOTVY4q4nljst0t4WjcGfg8NzNXgA2ZXX1Y=;
        b=GH420T82zMWBvjD7jgQG6Wcj8mKmBnqWvvkGB7lQBlDWsVBpXJVbu70T6WRwFADGEy
         ITGIPFDAXXwqD5P6J0Nx4x6foNtODEEFeNZuPJHRX3PRj8B+SloZ9FhafXrzPo2YO9KH
         QHrmfjJBRbBz1M1Bb+kurbGoZUSPAw6gKTu+YF+dN9ObMgcfI+dUGYDXUsbE90A0GBl7
         Jh4Enj0o4fnXmzCMomqaxzo9rJiN/lwzPHA8MtCFO6EecJOARV/hPMIT7j5DmssYuBVw
         van4uQRk+OIH6dvIDHKEYs+ns+icfVBxrCYMbSsSKGWH1z4rxbqzBlwHQEES6m7usAOC
         4q6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :reply-to:in-reply-to:references:mime-version:x-gm-message-state
         :from:to:cc:subject:date;
        bh=W+b+9jSnMOTVY4q4nljst0t4WjcGfg8NzNXgA2ZXX1Y=;
        b=zKGN+NInwluUVNqZNnk3A3PPh04wOGbNeo/EL2JD9EqNlg5OhDgrFAy4yRt5iINMwi
         9/tmTSMCde/yp0sN4WlyT6exljT3UekEyRxlNyPVjmcxcUA6qJdoduwuo9X659IZmSqQ
         h/9mo2WLPKe+Rv5Y8TIbLE1esUNHzOFLAb8nbJhYjXasymgGXjrNap9TOjBLFXticu/C
         sEvZPqXwOrB7Z8110D+cN/V4CngG79Ji0T+D/a7OkthpwzizZjsovBQm5k2IjHvjBe/i
         JVYWIBUW2X6venymSZLYB4MGt3SH/oY5w1rylkiQfB3ZhXgPFp4juRR9wUVAJOjKXsj+
         Rz3Q==
X-Gm-Message-State: ACgBeo1IQ7BoJq+OW4U2DfjIOKq9a9WZW/iV4NvzC9s3wrOiG1dyjoxs
        SjlWrDztXUhJW7e4x4t4xncbWHLDBR5fzaKhRck=
X-Google-Smtp-Source: AA6agR4qxOBTY0jrhtk0Yodj7YkZtI4pjD16vhB2KXpWSZ+0lezMMQadn7FkCpLjv1oySyVhl9k14krA7OMQrXUS/6Y=
X-Received: by 2002:a05:6870:ea83:b0:fe:365f:cb9d with SMTP id
 s3-20020a056870ea8300b000fe365fcb9dmr2448314oap.98.1662130124030; Fri, 02 Sep
 2022 07:48:44 -0700 (PDT)
MIME-Version: 1.0
References: <20220901225849.42898-1-shr@fb.com> <20220901225849.42898-2-shr@fb.com>
In-Reply-To: <20220901225849.42898-2-shr@fb.com>
Reply-To: fdmanana@gmail.com
From:   Filipe Manana <fdmanana@gmail.com>
Date:   Fri, 2 Sep 2022 15:48:07 +0100
Message-ID: <CAL3q7H7Xm+HkUXE6zeT+0fH+9Hi9XhE7gXH7mYcGeAoYR5D2XQ@mail.gmail.com>
Subject: Re: [PATCH v1 01/10] btrfs: implement a nowait option for tree searches
To:     Stefan Roesch <shr@fb.com>
Cc:     kernel-team@fb.com, io-uring@vger.kernel.org,
        linux-btrfs@vger.kernel.org, axboe@kernel.dk, josef@toxicpanda.com
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

On Fri, Sep 2, 2022 at 12:01 AM Stefan Roesch <shr@fb.com> wrote:
>
> From: Josef Bacik <josef@toxicpanda.com>
>
> For NOWAIT IOCB's we'll need a way to tell search to not wait on locks
> or anything.  Accomplish this by adding a path->nowait flag that will
> use trylocks and skip reading of metadata, returning -EWOULDBLOCK in
> either of these cases.  For now we only need this for reads, so only the
> read side is handled.  Add an ASSERT() to catch anybody trying to use
> this for writes so they know they'll have to implement the write side.
>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>  fs/btrfs/ctree.c   | 39 ++++++++++++++++++++++++++++++++++++---
>  fs/btrfs/ctree.h   |  1 +
>  fs/btrfs/locking.c | 23 +++++++++++++++++++++++
>  fs/btrfs/locking.h |  1 +
>  4 files changed, 61 insertions(+), 3 deletions(-)
>
> diff --git a/fs/btrfs/ctree.c b/fs/btrfs/ctree.c
> index ebfa35fe1c38..052c768b2297 100644
> --- a/fs/btrfs/ctree.c
> +++ b/fs/btrfs/ctree.c
> @@ -1447,6 +1447,11 @@ read_block_for_search(struct btrfs_root *root, str=
uct btrfs_path *p,
>                         return 0;
>                 }
>
> +               if (p->nowait) {
> +                       free_extent_buffer(tmp);
> +                       return -EWOULDBLOCK;
> +               }
> +
>                 if (unlock_up)
>                         btrfs_unlock_up_safe(p, level + 1);
>
> @@ -1467,6 +1472,8 @@ read_block_for_search(struct btrfs_root *root, stru=
ct btrfs_path *p,
>                         ret =3D -EAGAIN;
>
>                 goto out;
> +       } else if (p->nowait) {
> +               return -EWOULDBLOCK;
>         }
>
>         if (unlock_up) {
> @@ -1634,7 +1641,13 @@ static struct extent_buffer *btrfs_search_slot_get=
_root(struct btrfs_root *root,
>                  * We don't know the level of the root node until we actu=
ally
>                  * have it read locked
>                  */
> -               b =3D btrfs_read_lock_root_node(root);
> +               if (p->nowait) {
> +                       b =3D btrfs_try_read_lock_root_node(root);
> +                       if (IS_ERR(b))
> +                               return b;
> +               } else {
> +                       b =3D btrfs_read_lock_root_node(root);
> +               }
>                 level =3D btrfs_header_level(b);
>                 if (level > write_lock_level)
>                         goto out;
> @@ -1910,6 +1923,13 @@ int btrfs_search_slot(struct btrfs_trans_handle *t=
rans, struct btrfs_root *root,
>         WARN_ON(p->nodes[0] !=3D NULL);
>         BUG_ON(!cow && ins_len);
>
> +       /*
> +        * For now only allow nowait for read only operations.  There's n=
o
> +        * strict reason why we can't, we just only need it for reads so =
I'm
> +        * only implementing it for reads right now.
> +        */
> +       ASSERT(!p->nowait || !cow);
> +
>         if (ins_len < 0) {
>                 lowest_unlock =3D 2;
>
> @@ -1936,7 +1956,12 @@ int btrfs_search_slot(struct btrfs_trans_handle *t=
rans, struct btrfs_root *root,
>
>         if (p->need_commit_sem) {
>                 ASSERT(p->search_commit_root);
> -               down_read(&fs_info->commit_root_sem);
> +               if (p->nowait) {
> +                       if (!down_read_trylock(&fs_info->commit_root_sem)=
)
> +                               return -EAGAIN;

Why EAGAIN here and everywhere else EWOULDBLOCK? See below.

> +               } else {
> +                       down_read(&fs_info->commit_root_sem);
> +               }
>         }
>
>  again:
> @@ -2082,7 +2107,15 @@ int btrfs_search_slot(struct btrfs_trans_handle *t=
rans, struct btrfs_root *root,
>                                 btrfs_tree_lock(b);
>                                 p->locks[level] =3D BTRFS_WRITE_LOCK;
>                         } else {
> -                               btrfs_tree_read_lock(b);
> +                               if (p->nowait) {
> +                                       if (!btrfs_try_tree_read_lock(b))=
 {
> +                                               free_extent_buffer(b);
> +                                               ret =3D -EWOULDBLOCK;

Like here, this try lock failed and we are returning EWOULDBLOCK
instead of EAGAIN like above.

I'm also confused because in the followup patches I don't see
EWOULDBLOCK converted to EAGAIN to return to io_uring.
Currently we return EAGAIN for direct IO with NOWAIT when we need to
block or fallback to buffered IO. Does this means
that EWOULDBLOCK is also valid, or that somehow it's special for
buffered writes only?

> +                                               goto done;
> +                                       }
> +                               } else {
> +                                       btrfs_tree_read_lock(b);
> +                               }
>                                 p->locks[level] =3D BTRFS_READ_LOCK;
>                         }
>                         p->nodes[level] =3D b;
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 9ef162dbd4bc..d6d05450198d 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -443,6 +443,7 @@ struct btrfs_path {
>          * header (ie. sizeof(struct btrfs_item) is not included).
>          */
>         unsigned int search_for_extension:1;
> +       unsigned int nowait:1;

This misses several other places that relate to searches outside
btrfs_search_slot().
E.g. btrfs_search_old_slot(), btrfs_next_old_leaf() (used by
btrfs_next_leaf()), btrfs_search_forward() - possibly others too.

I understand those places were not changed because they're not needed
in the buffered write path (nor direct IO).

For the sake of completeness, should we deal with them, or at least
add an ASSERT in case path->nowait is set so that we don't forget
about them
in case in the future we get those other paths used in a NOWAIT
context (and that would be easy to miss).

Otherwise, it looks good to me.

Thanks.

>  };
>  #define BTRFS_MAX_EXTENT_ITEM_SIZE(r) ((BTRFS_LEAF_DATA_SIZE(r->fs_info)=
 >> 4) - \
>                                         sizeof(struct btrfs_item))
> diff --git a/fs/btrfs/locking.c b/fs/btrfs/locking.c
> index 9063072b399b..acc6ffeb2cda 100644
> --- a/fs/btrfs/locking.c
> +++ b/fs/btrfs/locking.c
> @@ -285,6 +285,29 @@ struct extent_buffer *btrfs_read_lock_root_node(stru=
ct btrfs_root *root)
>         return eb;
>  }
>
> +/*
> + * Loop around taking references on and locking the root node of the tre=
e in
> + * nowait mode until we end up with a lock on the root node or returning=
 to
> + * avoid blocking.
> + *
> + * Return: root extent buffer with read lock held or -EWOULDBLOCK.
> + */
> +struct extent_buffer *btrfs_try_read_lock_root_node(struct btrfs_root *r=
oot)
> +{
> +       struct extent_buffer *eb;
> +
> +       while (1) {
> +               eb =3D btrfs_root_node(root);
> +               if (!btrfs_try_tree_read_lock(eb))
> +                       return ERR_PTR(-EWOULDBLOCK);
> +               if (eb =3D=3D root->node)
> +                       break;
> +               btrfs_tree_read_unlock(eb);
> +               free_extent_buffer(eb);
> +       }
> +       return eb;
> +}
> +
>  /*
>   * DREW locks
>   * =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> diff --git a/fs/btrfs/locking.h b/fs/btrfs/locking.h
> index ab268be09bb5..490c7a79e995 100644
> --- a/fs/btrfs/locking.h
> +++ b/fs/btrfs/locking.h
> @@ -94,6 +94,7 @@ int btrfs_try_tree_read_lock(struct extent_buffer *eb);
>  int btrfs_try_tree_write_lock(struct extent_buffer *eb);
>  struct extent_buffer *btrfs_lock_root_node(struct btrfs_root *root);
>  struct extent_buffer *btrfs_read_lock_root_node(struct btrfs_root *root)=
;
> +struct extent_buffer *btrfs_try_read_lock_root_node(struct btrfs_root *r=
oot);
>
>  #ifdef CONFIG_BTRFS_DEBUG
>  static inline void btrfs_assert_tree_write_locked(struct extent_buffer *=
eb)
> --
> 2.30.2
>


--=20
Filipe David Manana,

=E2=80=9CWhether you think you can, or you think you can't =E2=80=94 you're=
 right.=E2=80=9D
