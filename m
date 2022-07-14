Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFED5741AD
	for <lists+io-uring@lfdr.de>; Thu, 14 Jul 2022 05:00:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232141AbiGNDA4 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 13 Jul 2022 23:00:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231842AbiGNDA4 (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 13 Jul 2022 23:00:56 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06D3F2127C
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 20:00:55 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id v14so729771wra.5
        for <io-uring@vger.kernel.org>; Wed, 13 Jul 2022 20:00:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+xwAXAvYI9FTbVDjyFeCH64OhB8MXdH0zkgpyggSvUk=;
        b=dMCsTIAFAcgVHxxSiOLpbduJW+c7ON7UybqBzef+4ZnZnGUYbSLHechQQdGPF7SLa7
         Xcl7s4pBFVoASRgo8sggxFSu0BuIzvYnjIauzoDCpmOkbiJ0k9J1yofYL6Jd4W4OpCIZ
         vZu+IImCn4t+odtM7993ooGtuwJET10zE1b7fZ+moMrtVjeylBBr/DN4V+ukrwSozaKX
         Mqln9AlXkZphrX0FvdbJulL0n7XymjCkeZFn/W0jQICg7syyUfDLs6lB6aymnFGRCaFw
         Emz39/ROBeBxLQ42xcazo+DFBJCTkt9AR+z/KHtFFfj9P2fu49qjTkTmUyCKmQd7LDPf
         1w5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+xwAXAvYI9FTbVDjyFeCH64OhB8MXdH0zkgpyggSvUk=;
        b=wZ+7+24DqLuAyeWGdLpWHFnEHbH1RTMJ42NLYe3LVJrsQGAJvxwJ94rxVmgQbX+htQ
         0RwTyGsKvnG7QEn8IyhNuygSEHYRflnzTn6J3kuyUxUHWeaDxFeSQlGMI3jbHe75IR+q
         Vk2eS0XKhBXxfI9+ALAG0MA94IA13NwxltlCpFTXmYwHQ+567h5ZzS228d8pOESmSxgG
         IzNjN2cmpC7LTAAcwOzx0j3oxI4dwARAUxlyM+4afwLzZemVhPyb2rIvn5Vz/zuGralK
         mvL8FJ5GlHUrflQz7e/KAS7WmrmNmT/X9Kp7OZR2qGYXNYbWWQpJW+Ds2hrleHUf3Z8G
         Vzzg==
X-Gm-Message-State: AJIora/UK4EYtNGz4HKIlS4cJc7vKu7xL691DTuLzowTk1GGcclW4PS5
        /ZiwkHcxhc6/vpmrkQUFhhcw2n9RJYYbebINktpIDs4WV7XU
X-Google-Smtp-Source: AGRyM1vvo+tthDYWScteO4hpZvrGvs19yHNivGyWRsakaG8eMJ8KqyISvXRV6JQGpJ44lzvE5fOckdhkSSV/DO8/okM=
X-Received: by 2002:a5d:64a3:0:b0:21d:adaa:ce4c with SMTP id
 m3-20020a5d64a3000000b0021dadaace4cmr6001437wrp.161.1657767653490; Wed, 13
 Jul 2022 20:00:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220714000536.2250531-1-mcgrof@kernel.org>
In-Reply-To: <20220714000536.2250531-1-mcgrof@kernel.org>
From:   Paul Moore <paul@paul-moore.com>
Date:   Wed, 13 Jul 2022 23:00:42 -0400
Message-ID: <CAHC9VhSjfrMtqy_6+=_=VaCsJKbKU1oj6TKghkue9LrLzO_++w@mail.gmail.com>
Subject: Re: [PATCH] lsm,io_uring: add LSM hooks to for the new uring_cmd file op
To:     Luis Chamberlain <mcgrof@kernel.org>
Cc:     axboe@kernel.dk, casey@schaufler-ca.com, joshi.k@samsung.com,
        linux-security-module@vger.kernel.org, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-block@vger.kernel.org,
        a.manzanares@samsung.com, javier@javigon.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Wed, Jul 13, 2022 at 8:05 PM Luis Chamberlain <mcgrof@kernel.org> wrote:
>
> io-uring cmd support was added through ee692a21e9bf ("fs,io_uring:
> add infrastructure for uring-cmd"), this extended the struct
> file_operations to allow a new command which each subsystem can use
> to enable command passthrough. Add an LSM specific for the command
> passthrough which enables LSMs to inspect the command details.
>
> This was discussed long ago without no clear pointer for something
> conclusive, so this enables LSMs to at least reject this new file
> operation.
>
> [0] https://lkml.kernel.org/r/8adf55db-7bab-f59d-d612-ed906b948d19@schaufler-ca.com

[NOTE: I now see that the IORING_OP_URING_CMD has made it into the
v5.19-rcX releases, I'm going to be honest and say that I'm
disappointed you didn't post the related LSM additions until
v5.19-rc6, especially given our earlier discussions.]

While the earlier discussion may not have offered a detailed approach
on how to solve this, I think it was rather conclusive in that the
approach used then (and reproduced here) did not provide enough
context to the LSMs to be able to make a decision.  There were similar
concerns when it came to auditing the command passthrough.  It appears
that most of my concerns in the original thread still apply to this
patch.

Given the LSM hook in this patch, it is very difficult (impossible?)
to determine the requested operation as these command opcodes are
device/subsystem specific.  The unfortunate result is that the LSMs
are likely going to either allow all, or none, of the commands for a
given device/subsystem, and I think we can all agree that is not a
good idea.

That is the critical bit of feedback on this patch, but there is more
feedback inline below.

> Signed-off-by: Luis Chamberlain <mcgrof@kernel.org>
> ---
>  include/linux/lsm_hook_defs.h | 1 +
>  include/linux/lsm_hooks.h     | 3 +++
>  include/linux/security.h      | 5 +++++
>  io_uring/uring_cmd.c          | 5 +++++
>  security/security.c           | 4 ++++
>  5 files changed, 18 insertions(+)

...

> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index 0a421ed51e7e..5e666aa7edb8 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -3,6 +3,7 @@
>  #include <linux/errno.h>
>  #include <linux/file.h>
>  #include <linux/io_uring.h>
> +#include <linux/security.h>
>
>  #include <uapi/linux/io_uring.h>
>
> @@ -82,6 +83,10 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>         struct file *file = req->file;
>         int ret;
>
> +       ret = security_uring_cmd(ioucmd);
> +       if (ret)
> +               return ret;
> +
>         if (!req->file->f_op->uring_cmd)
>                 return -EOPNOTSUPP;
>

In order to be consistent with most of the other LSM hooks, the
'req->file->f_op->uring_cmd' check should come before the LSM hook
call.  The general approach used in most places is to first validate
the request and do any DAC based access checks before calling into the
LSM.

-- 
paul-moore.com
