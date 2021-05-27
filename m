Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F105E393816
	for <lists+io-uring@lfdr.de>; Thu, 27 May 2021 23:43:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234725AbhE0VpN (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 27 May 2021 17:45:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234696AbhE0VpN (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 27 May 2021 17:45:13 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE0F8C061574
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 14:43:38 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id f8so1330052pjh.0
        for <io-uring@vger.kernel.org>; Thu, 27 May 2021 14:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V2Kx9CWiwh36E+i8wyJDGVe9Kt7xTL6Zg4r3FJ09PlU=;
        b=oqdHHcKUVq3XePWEpQJwuK+P3jMOSe8no1vQH4xiH8loU50tSfaiPi0H+uOJc1VgDq
         4HwvBurZwLU4WIdK083zcDLvTfn0Rwlr02Tjp+zT5UZywMMop+Wv44T4M1CznXyZDBeT
         LHf8B847v2lSosaIlWNQJ5kLA1NvIC5MDlhKz5ZU+kThkReLSyGfkjv2tI3XDMjIkcl4
         Ygnit3MIgEMkmY6x73DR/7ziHpvJ/Y/Ow5rmk386QIQ18cPyU8uNg7+YuC6jWJEoNrHA
         WmRCdq+MD1qmwSuk8VeH9h/eHq/7b9or5dui9XyEOkE7oJmi6NMc3TOJ96NsPHADhPr+
         ijDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V2Kx9CWiwh36E+i8wyJDGVe9Kt7xTL6Zg4r3FJ09PlU=;
        b=hM4fHWFiFmHZUdr4TSArZoWu7NcZWNPi+T78WRXDz2qZhi4f2fPwBn7CMcsKozhj0A
         sQkahtGEx9lulC/gg97jot9DIcOMi3hQJhxo5I3hhLELQWkbB1c36/RldLUID8N5mHGz
         pjyqjweAXW/yiD+I7zCnblS+8Ski1WeDJHFnYF1uWFjlz+4pV4b/hbecq+FH9cVq4tXn
         hjWOkqOuGo4ByQrRcXnKybxLGF3UQYBX7gYo7+K/EOg1BwZ4zAAJThv1yfiXY1NyHKmo
         8KBvd1Id5PoMZMwzWqXd3h3Sxpd9arcuMcsmElvri6Gg0arP+Ig1Z2pdjzPW1fB+b1Aw
         vapQ==
X-Gm-Message-State: AOAM5304P8PuMrpOECE9MHqJszs4mslmyzbRDqXJunJv7hEhvmaMamQx
        KAostsawPRxHUxVrYKLeWDaRYE5pALqkfHP9Vfrc7ef+40i51Q==
X-Google-Smtp-Source: ABdhPJw1lBlrSy2H2q7aCnEdFMf++M8ZKxiW+UUpWJEyfAZRYm9PLGGyYn0O91dlQj8ykHUJJ6Z1zVzVNr6A0Yf5Ths=
X-Received: by 2002:a17:902:7b85:b029:fb:c187:2bed with SMTP id
 w5-20020a1709027b85b02900fbc1872bedmr4971867pll.67.1622151818267; Thu, 27 May
 2021 14:43:38 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1621899872.git.asml.silence@gmail.com> <5290fc671b3f5db3ff2a20e2242dd39eba01ec1d.1621899872.git.asml.silence@gmail.com>
In-Reply-To: <5290fc671b3f5db3ff2a20e2242dd39eba01ec1d.1621899872.git.asml.silence@gmail.com>
From:   Noah Goldstein <goldstein.w.n@gmail.com>
Date:   Thu, 27 May 2021 17:43:27 -0400
Message-ID: <CAFUsyfL-QOT8tRUNz6Ch5i4pFoB=wMxFemk5CSfWdLHCeRMq5A@mail.gmail.com>
Subject: Re: [PATCH 10/13] io_uring: add helpers for 2 level table alloc
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        "open list:IO_URING" <io-uring@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 24, 2021 at 7:51 PM Pavel Begunkov <asml.silence@gmail.com> wrote:
>
> Some parts like fixed file table use 2 level tables, factor out helpers
> for allocating/deallocating them as more users are to come.
>
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  fs/io_uring.c | 73 ++++++++++++++++++++++++++++++---------------------
>  1 file changed, 43 insertions(+), 30 deletions(-)
>
> diff --git a/fs/io_uring.c b/fs/io_uring.c
> index 40b70c34c1b2..1cc2d16637ff 100644
> --- a/fs/io_uring.c
> +++ b/fs/io_uring.c
> @@ -7054,14 +7054,36 @@ static int io_cqring_wait(struct io_ring_ctx *ctx, int min_events,
>         return READ_ONCE(rings->cq.head) == READ_ONCE(rings->cq.tail) ? ret : 0;
>  }
>
> -static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
> +static void io_free_page_table(void **table, size_t size)
>  {
> -       unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
> +       unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
>
>         for (i = 0; i < nr_tables; i++)
> -               kfree(table->files[i]);
> -       kfree(table->files);
> -       table->files = NULL;
> +               kfree(table[i]);
> +       kfree(table);
> +}
> +
> +static void **io_alloc_page_table(size_t size)
> +{
> +       unsigned i, nr_tables = DIV_ROUND_UP(size, PAGE_SIZE);
> +       size_t init_size = size;
> +       void **table;
> +
> +       table = kcalloc(nr_tables, sizeof(*table), GFP_KERNEL);
> +       if (!table)
> +               return NULL;
> +
> +       for (i = 0; i < nr_tables; i++) {
> +               unsigned int this_size = min(size, PAGE_SIZE);
> +
> +               table[i] = kzalloc(this_size, GFP_KERNEL);
> +               if (!table[i]) {
> +                       io_free_page_table(table, init_size);
> +                       return NULL;
Unless zalloc returns non-NULL for size == 0, you are guranteed to do
this for size <= PAGE_SIZE * (nr_tables - 1).  Possibly worth calculating early?

If you calculate early you could then make the loop:

for (i = 0; i < nr_tables - 1; i++) {
    table[i] = kzalloc(PAGE_SIZE, GFP_KERNEL);
    if (!table[i]) {
        io_free_page_table(table, init_size);
        return NULL;
    }
}

table[i] = kzalloc(size - (nr_tables - 1) * PAGE_SIZE, GFP_KERNEL);
    if (!table[i]) {
        io_free_page_table(table, init_size);
        return NULL;
    }

Which is almost certainly faster.

> +               }
> +               size -= this_size;
> +       }
> +       return table;
>  }
>
>  static inline void io_rsrc_ref_lock(struct io_ring_ctx *ctx)
> @@ -7190,6 +7212,22 @@ static int io_rsrc_data_alloc(struct io_ring_ctx *ctx, rsrc_put_fn *do_put,
>         return 0;
>  }
>
> +static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
> +{
> +       size_t size = nr_files * sizeof(struct io_fixed_file);
> +
> +       table->files = (struct io_fixed_file **)io_alloc_page_table(size);
> +       return !!table->files;
> +}
> +
> +static void io_free_file_tables(struct io_file_table *table, unsigned nr_files)
> +{
> +       size_t size = nr_files * sizeof(struct io_fixed_file);
> +
> +       io_free_page_table((void **)table->files, size);
> +       table->files = NULL;
> +}
> +
>  static void __io_sqe_files_unregister(struct io_ring_ctx *ctx)
>  {
>  #if defined(CONFIG_UNIX)
> @@ -7451,31 +7489,6 @@ static int io_sqe_files_scm(struct io_ring_ctx *ctx)
>  }
>  #endif
>
> -static bool io_alloc_file_tables(struct io_file_table *table, unsigned nr_files)
> -{
> -       unsigned i, nr_tables = DIV_ROUND_UP(nr_files, IORING_MAX_FILES_TABLE);
> -
> -       table->files = kcalloc(nr_tables, sizeof(*table->files), GFP_KERNEL);
> -       if (!table->files)
> -               return false;
> -
> -       for (i = 0; i < nr_tables; i++) {
> -               unsigned int this_files = min(nr_files, IORING_MAX_FILES_TABLE);
> -
> -               table->files[i] = kcalloc(this_files, sizeof(*table->files[i]),
> -                                       GFP_KERNEL);
> -               if (!table->files[i])
> -                       break;
> -               nr_files -= this_files;
> -       }
> -
> -       if (i == nr_tables)
> -               return true;
> -
> -       io_free_file_tables(table, nr_tables * IORING_MAX_FILES_TABLE);
> -       return false;
> -}
> -
>  static void io_rsrc_file_put(struct io_ring_ctx *ctx, struct io_rsrc_put *prsrc)
>  {
>         struct file *file = prsrc->file;
> --
> 2.31.1
>
