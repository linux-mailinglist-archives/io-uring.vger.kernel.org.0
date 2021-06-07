Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3782139E9F4
	for <lists+io-uring@lfdr.de>; Tue,  8 Jun 2021 01:15:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230233AbhFGXRT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 7 Jun 2021 19:17:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230209AbhFGXRT (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 7 Jun 2021 19:17:19 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96FD5C061574
        for <io-uring@vger.kernel.org>; Mon,  7 Jun 2021 16:15:13 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id he7so9958437ejc.13
        for <io-uring@vger.kernel.org>; Mon, 07 Jun 2021 16:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=yVcvHZxl4JqB10edFM0rP0Xu4QSj7UArIpCEg3v5Ei8=;
        b=U7TfcbAM3zxrbqLIzDoEUv43hEGINXWMWhYClak8CfaaNFxcUhS/u8mLrcy4H1f/lL
         8Dv7Y0aXJzyPOgKgY1zRrNzyIhlGulAI+YN3MCJrf3gVmss94O+O82qMJfO/bLwWaU7K
         Ryc5eFkS0Oj1u3a6R7AvzqIVUGTS+E9WDcB/ZiJfGKXucs31Fa4hdrgUJYDdQapNOCLY
         8bXmuY/xVLkCKvbj/Rccpk63vbHR1DMPdYTLV2MM5bTfRDrB8T9ShsdDzfYu6nNfV3vI
         xduQ4zw+eJF/FWzKjySwuoij9H8dUNzRMPX0Gi7L0edr2pQBxPQVYlk04xQPRevi3Srl
         iPXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=yVcvHZxl4JqB10edFM0rP0Xu4QSj7UArIpCEg3v5Ei8=;
        b=j/Ualp+ifxFSd+qjXsvJBwR7w3XZH1IyycDrxHMixOfzwDRBPo2wEIIEF4DbtQw2B9
         YoDrCwgoUfmXRN+4S2q0AeG0P4fdwkG+gXT+AtzYB6lvj6HD4S/vJuMYYoC6xUK6z9bn
         Jo7Zx93zDFlMRIrrhWDqvH5xB5IyiTra9+zvCRhqNcq3YqKQ2QZ0gRbGeBRYxtXk8rFJ
         7eRh4ma9GKHmvDDOEvLSjkhN+s+NEmi5PZ7+f1ImEGJKncwoxvpKcotoowE4/pSnIA+7
         Bs+CnEVNt9CVRu/E9V+muiDDL5iRxjse3mFMxl2Y1O2f9dJ3AFFi/dfT9Mtwqy8i3XCf
         y9GQ==
X-Gm-Message-State: AOAM532hlYXZ9kfc8tAuKp+2wthH88m1dMmrtVXsGTFxwO69ti8FSfW0
        cAZ9L/3E6kt2OFd7AKzYAojqLsKMu55S302BxMQc
X-Google-Smtp-Source: ABdhPJwQmKKFjCUccixQJ2loM5vdZurrcHLgZFSdBmxemrGWy9aCkt/1ll1v8r13AIWiK1ynSFD9QO7MXzHvxVJN8wk=
X-Received: by 2002:a17:906:518b:: with SMTP id y11mr20728839ejk.178.1623107712097;
 Mon, 07 Jun 2021 16:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <CAHC9VhTr_hw_RBPf5yGD16j-qV2tbjjPJkimMNNQZBHtrJDbuQ@mail.gmail.com>
 <3a2903574a4d03f73230047866112b2dad9b4a9e.1622467740.git.rgb@redhat.com>
In-Reply-To: <3a2903574a4d03f73230047866112b2dad9b4a9e.1622467740.git.rgb@redhat.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Mon, 7 Jun 2021 19:15:01 -0400
Message-ID: <CAHC9VhRa9dvCfPf5WHKYofrvQrGff7Lh+H4HMAhi_z3nK_rtoA@mail.gmail.com>
Subject: Re: [PATCH 1/2] audit: add filtering for io_uring records, addendum
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     linux-audit@redhat.com, io-uring@vger.kernel.org,
        linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org, selinux@vger.kernel.org,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Jens Axboe <axboe@kernel.dk>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Mon, May 31, 2021 at 9:45 AM Richard Guy Briggs <rgb@redhat.com> wrote:
>
> The commit ("audit: add filtering for io_uring records") added support for
> filtering io_uring operations.
>
> Add checks to the audit io_uring filtering code for directory and path watches,
> and to keep the list counts consistent.
>
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
>  kernel/audit_tree.c  | 3 ++-
>  kernel/audit_watch.c | 3 ++-
>  kernel/auditfilter.c | 7 +++++--
>  3 files changed, 9 insertions(+), 4 deletions(-)

Thanks for pointing these omissions out in the original patch.  When a
patch has obvious problems generally people just provide feedback and
the patch author incorporates the fixes; this helps ensure we don't
merge known broken patches, helping preserve `git bisect`.

Do you mind if I incorporate these suggestions, and the one in patch
2/2, into the filtering patch in the original RFC patchset?  I'll add
a 'thank you' comment in the commit description as I did to the other
patch where you provided feedback.  I feel that is the proper way to
handle this.

> diff --git a/kernel/audit_tree.c b/kernel/audit_tree.c
> index 6c91902f4f45..2be285c2f069 100644
> --- a/kernel/audit_tree.c
> +++ b/kernel/audit_tree.c
> @@ -727,7 +727,8 @@ int audit_make_tree(struct audit_krule *rule, char *pathname, u32 op)
>  {
>
>         if (pathname[0] != '/' ||
> -           rule->listnr != AUDIT_FILTER_EXIT ||
> +           (rule->listnr != AUDIT_FILTER_EXIT &&
> +            rule->listnr != AUDIT_FILTER_URING_EXIT) ||
>             op != Audit_equal ||
>             rule->inode_f || rule->watch || rule->tree)
>                 return -EINVAL;
> diff --git a/kernel/audit_watch.c b/kernel/audit_watch.c
> index 2acf7ca49154..698b62b4a2ec 100644
> --- a/kernel/audit_watch.c
> +++ b/kernel/audit_watch.c
> @@ -183,7 +183,8 @@ int audit_to_watch(struct audit_krule *krule, char *path, int len, u32 op)
>                 return -EOPNOTSUPP;
>
>         if (path[0] != '/' || path[len-1] == '/' ||
> -           krule->listnr != AUDIT_FILTER_EXIT ||
> +           (krule->listnr != AUDIT_FILTER_EXIT &&
> +            krule->listnr != AUDIT_FILTER_URING_EXIT) ||
>             op != Audit_equal ||
>             krule->inode_f || krule->watch || krule->tree)
>                 return -EINVAL;
> diff --git a/kernel/auditfilter.c b/kernel/auditfilter.c
> index c21119c00504..bcdedfd1088c 100644
> --- a/kernel/auditfilter.c
> +++ b/kernel/auditfilter.c
> @@ -153,7 +153,8 @@ char *audit_unpack_string(void **bufp, size_t *remain, size_t len)
>  static inline int audit_to_inode(struct audit_krule *krule,
>                                  struct audit_field *f)
>  {
> -       if (krule->listnr != AUDIT_FILTER_EXIT ||
> +       if ((krule->listnr != AUDIT_FILTER_EXIT &&
> +            krule->listnr != AUDIT_FILTER_URING_EXIT) ||
>             krule->inode_f || krule->watch || krule->tree ||
>             (f->op != Audit_equal && f->op != Audit_not_equal))
>                 return -EINVAL;
> @@ -250,6 +251,7 @@ static inline struct audit_entry *audit_to_entry_common(struct audit_rule_data *
>                 pr_err("AUDIT_FILTER_ENTRY is deprecated\n");
>                 goto exit_err;
>         case AUDIT_FILTER_EXIT:
> +       case AUDIT_FILTER_URING_EXIT:
>         case AUDIT_FILTER_TASK:
>  #endif
>         case AUDIT_FILTER_USER:
> @@ -982,7 +984,8 @@ static inline int audit_add_rule(struct audit_entry *entry)
>         }
>
>         entry->rule.prio = ~0ULL;
> -       if (entry->rule.listnr == AUDIT_FILTER_EXIT) {
> +       if (entry->rule.listnr == AUDIT_FILTER_EXIT ||
> +           entry->rule.listnr == AUDIT_FILTER_URING_EXIT) {
>                 if (entry->rule.flags & AUDIT_FILTER_PREPEND)
>                         entry->rule.prio = ++prio_high;
>                 else
> --
> 2.27.0

-- 
paul moore
www.paul-moore.com
