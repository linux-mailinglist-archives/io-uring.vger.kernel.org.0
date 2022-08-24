Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11F3E59F013
	for <lists+io-uring@lfdr.de>; Wed, 24 Aug 2022 02:05:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbiHXAFT (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 23 Aug 2022 20:05:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58690 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231987AbiHXAFR (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 23 Aug 2022 20:05:17 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC33D41998
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 17:05:12 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id v125so17918277oie.0
        for <io-uring@vger.kernel.org>; Tue, 23 Aug 2022 17:05:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc;
        bh=N31nAi7W+JKnQPuiEmt8aB2CyQkls45hZzNKhxTpXIM=;
        b=0TebYhqc/X0Jue/beYWD56gVFsbfawWjX/lRTru/5CeXawtyto1zzq6V3IoRtxe5Cn
         LwVECVXbJ7jWFS2eeNp+D+AyEP9Ka/fiJmGrApd9MJKV/wpURjnn4vM4fvXVbe97+R0U
         ebYalREtAjZhBthaHVrVMBTMEeNU/ppdENIthogO6m6B3pUSLu+ew3PdaXpKX9i6iLPk
         +RVILtledIbiyx/dofa+TecODmazCeW36Xj6lb38ACujSErGeepZvQZl03JzqBsrbEhJ
         LebyHqXj3mQUxG5zLa1HdVYawW3o+Ljwr3ZJpDWW6CQQpFR/0kleAQNYy9q2RV99MG+H
         Y5EA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=N31nAi7W+JKnQPuiEmt8aB2CyQkls45hZzNKhxTpXIM=;
        b=Iifsj/17r7Mji0Z3HKN+wcDPyeupOUV8rUwgw2tLcJXrDyzFad6jlyfKlGElktgBX0
         jqo5YUvehVRTsDdqHV1Hnyx0NUZ8ckRVsBvv8TFNqvxCTB5fszJEVqj0V3Mq1KMlhvKe
         N+XRWuvWTK9lGsCyGjVMFB1yOmGWttGkD/o2EqRQr6MwACU7EEFcmUIzgcPNsDi0N+7y
         30Ef2bOPSCoHuWBAe0eCRTwcR58uBA8/xL/SqlgwOSGd+BbY6AbbOfHFDWmgKaJhbzQb
         N4GPX0uU6FllLEEoFgQBOhSgPWfzVEaEJaLbrUK8GFPFuDC6t/Desk+V3CTdZ2CIggJZ
         12iA==
X-Gm-Message-State: ACgBeo1IJB1Ksy8AcswKEXudVa/LynHWbP48HcCtdJQw6jaJjfCFhRl5
        KivAW6GCqnzVNZ6eqA3sTeIZ6NEfWBs6g8hQiEYu
X-Google-Smtp-Source: AA6agR4ReyAx4E5bf0bG0h1kK5wkcSdI5nfW+iQGZ9sBzssmNYF3ZT02VSWc5o6m7Es9xSDE0AvO4kVhduLSzRnLt3s=
X-Received: by 2002:a05:6808:3a9:b0:343:4b14:ccce with SMTP id
 n9-20020a05680803a900b003434b14cccemr2285855oie.41.1661299512107; Tue, 23 Aug
 2022 17:05:12 -0700 (PDT)
MIME-Version: 1.0
References: <CGME20220719135821epcas5p1b071b0162cc3e1eb803ca687989f106d@epcas5p1.samsung.com>
 <20220719135234.14039-1-ankit.kumar@samsung.com> <116e04c2-3c45-48af-65f2-87fce6826683@schaufler-ca.com>
 <fc1e774f-8e7f-469c-df1a-e1ababbd5d64@kernel.dk> <CAHC9VhSBqWFBJrAdKVF5f3WR6gKwPq-+gtFR3=VkQ8M4iiNRwQ@mail.gmail.com>
 <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
In-Reply-To: <83a121d5-a2ec-197b-708c-9ea2f9d0bd6a@schaufler-ca.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Tue, 23 Aug 2022 20:05:01 -0400
Message-ID: <CAHC9VhQStPdfWwTKwqfz67hr3PErHmdu+s_3mAfATb0mu7MD2w@mail.gmail.com>
Subject: Re: [PATCH] Smack: Provide read control for io_uring_cmd
To:     Casey Schaufler <casey@schaufler-ca.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        Ankit Kumar <ankit.kumar@samsung.com>,
        io-uring@vger.kernel.org, joshi.k@samsung.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On Tue, Aug 23, 2022 at 7:46 PM Casey Schaufler <casey@schaufler-ca.com> wrote:
>
> Limit io_uring "cmd" options to files for which the caller has
> Smack read access. There may be cases where the cmd option may
> be closer to a write access than a read, but there is no way
> to make that determination.
>
> Signed-off-by: Casey Schaufler <casey@schaufler-ca.com>
> --
>  security/smack/smack_lsm.c | 32 ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
>
> diff --git a/security/smack/smack_lsm.c b/security/smack/smack_lsm.c
> index 001831458fa2..bffccdc494cb 100644
> --- a/security/smack/smack_lsm.c
> +++ b/security/smack/smack_lsm.c

...

> @@ -4732,6 +4733,36 @@ static int smack_uring_sqpoll(void)
>         return -EPERM;
>  }
>
> +/**
> + * smack_uring_cmd - check on file operations for io_uring
> + * @ioucmd: the command in question
> + *
> + * Make a best guess about whether a io_uring "command" should
> + * be allowed. Use the same logic used for determining if the
> + * file could be opened for read in the absence of better criteria.
> + */
> +static int smack_uring_cmd(struct io_uring_cmd *ioucmd)
> +{
> +       struct file *file = ioucmd->file;
> +       struct smk_audit_info ad;
> +       struct task_smack *tsp;
> +       struct inode *inode;
> +       int rc;
> +
> +       if (!file)
> +               return -EINVAL;

Perhaps this is a better question for Jens, but ioucmd->file is always
going to be valid when the LSM hook is called, yes?

> +       tsp = smack_cred(file->f_cred);
> +       inode = file_inode(file);
> +
> +       smk_ad_init(&ad, __func__, LSM_AUDIT_DATA_PATH);
> +       smk_ad_setfield_u_fs_path(&ad, file->f_path);
> +       rc = smk_tskacc(tsp, smk_of_inode(inode), MAY_READ, &ad);
> +       rc = smk_bu_credfile(file->f_cred, file, MAY_READ, rc);
> +
> +       return rc;
> +}
> +
>  #endif /* CONFIG_IO_URING */

-- 
paul-moore.com
