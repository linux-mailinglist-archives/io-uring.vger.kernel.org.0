Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B44A633FF3
	for <lists+io-uring@lfdr.de>; Tue, 22 Nov 2022 16:18:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbiKVPSd (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Tue, 22 Nov 2022 10:18:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232611AbiKVPSc (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Tue, 22 Nov 2022 10:18:32 -0500
Received: from sonic309-26.consmr.mail.ne1.yahoo.com (sonic309-26.consmr.mail.ne1.yahoo.com [66.163.184.152])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1DF25E96
        for <io-uring@vger.kernel.org>; Tue, 22 Nov 2022 07:18:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1669130310; bh=lh0xvKqPsvTEab2FBjEgJnCksuYlIa0lLQsXPA4oQLM=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=D2fO3b9xz4e40Lee71Br56vAFY++o8Y22JxdK4P/DQ6kl2n0Ctx7Oib76ieJND92yEo6iuSGT2Y2KrgYNyIPbNOBCHA6gDqh5bzHTKvHqpSS8aNXzucUOK5YvXJFKrkYoSXZhG5GtHmX92q55x0z5cN5dPAddpLo7b0obJDKsWL5TWyXwj4RU+wv49duS7uehktWPaM1GhZ7k7GhgVsGqF0q8VZ3uqHqxdxV2040ZUeaPOTcwwiK8sgG0MxNJMaHjqZ4Ejm5NDLH35km9xXU2NZlW5inq8H1ZuuZAGY+mVyGM9QqBP7DHRlnUxe91dxqQNLXEyFFaMkH+88ZEigaHw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1669130310; bh=UVga/hSeeuCTS3fIJ4Vo02C4xpCRiVQ+J9fd9v9QTsH=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=nsqHzT23TcGMgmwyp5m0XLqSp5hbc7Mu2nc/ent4C/ARurY2I5PW7bTwo97gx+fzj1LBSy44UnQP5BZhF2E4pVWFtfp4OUISUgC6ybfJctMbS5AzPdbdZGxfwg2dG7Lo3G3ONtl4HAx42nqBAvyoeTnDXL4jlhjjHqUi5JcV/GLO1qekJnvqBgpE4uMdnt2RilC4gEwOJ8d7YIXQ0R2oZDHXhwHTiYPDENaO4Sk9jY9QfV6Z3+PhKtH7X0FSHK7xq7RjCYb7zduBemLHOB2ABsITTK8w2Ei62obYfmhNhNYI6rOpsTDdVyQYXAD9JkOEpvd9KRB81Q+Obhbgpekc+Q==
X-YMail-OSG: MjekJCAVM1nAIjDws8gKPVrM5kk_rZA7_pGvKR7BprCvQ0rkyzbTLfCMVGi4dSl
 rI4PT_l44bG2Ks7CYZ_CmjSW2xxIMAKdn1gvQJ3jBOPvHo.PtqH_Kfk2uDSb6SRURenJeK.e3_J_
 XjUPFL6Kb.x.ClY8FR.DfalO9t0.jrdjjhPapbvehhnmVg0FamufvwEgTKKOAiHq4MMnJCUknYH.
 RKtUTdtcyASAMQll4tY7JHG0hacPnihWhK67KKh9OZnjjoyFuo7r.gORgkb8McllaWhznU0N7tl5
 gfQVIjaSz2j5lxBnoolSDgbYgrWz.so4Dc37MBhUoo.x8b.lfNpdIW6XTYFJpfQ9y8jpsnx21nT8
 .cwPW3kRlwcx_hJMiwM6oSwgeixPOiUsvD8JHMW1RXbweAA6rst3FHqStljODraMq.3UNA9PqJ07
 XlqB6fOBRnvniJFh7tdmq6tnnkh.FCiT1TZtbOhBhcqwQipBPs10bpANMv4qVr0ViDv9vr8f9h0s
 wSQSjYMDiQelaAy0QiLctFKKt72epuB8vubfN49SShrA.SdbmN5g4yTls.pB0kWFx6OUuv6YgaER
 R0v1xKLbrQmtxYXE9s0cD37FaUIigK4OJ55lITg._fcWCI8EvazjxWjpEZYHbwUXnHNVZr7rooso
 LbxwK65Ef6uHdK7114tlKOja9vwTa4m2JT9d6ozBB6YIcQnUCeWtnVHJjG2DjysSMPTnv3vSRaZ9
 qKDZ0JyldIzMJbErdNeJEkSMihoM7qbEDf7Fqg.oD.QGiBU2TA6gAC6yHBeATOxQPWJMeOAVODho
 uBoG2s8cbskUuLkUlQ4qq1x30jLRfzw4kW8CT6T4Bl2xZFemsxbNmscNnGK1Mkah85AdPZ1K_H7e
 p1ZF6RtZhmJ2N191.JrKJuwZ.GV9S4UQVHY8lOoY.CqAns3d4Rlw9p.jvMx62yMphusIHCUdZqBN
 XxMS3Zpj8sR46uRi2h2ZkFBubbKepvP48OOMvl552mLJlXWnEcflRpJ1Sf8fMpWE4qWAaYisuAcw
 gw_8zQ9WtLoaJ89uL4J3DZXINfm0_98KnX7nCts.59ss3zbwIXjZIR.VeXLYJsVyTY4P1ptLqHC_
 B5iP_Tg6QXS3InO3MFlZXziursbFaalCFELR2AsQWONcGgCZlCVa8mdeztvUywbmrBRGrn71wu57
 WfHfEyd42ijTsztZk8DXQmbPyK1AQcLd9lS3DyE.rbeqzZcropQ3LbMJhrX9aHYIi677Lr0fxEqT
 JqT09Jcqz40XwQyZEW4QJWa74aC0plJZYreoFApEDlWlxNuIObEOD43pHJ7j4t0JyMMQGQwYynD5
 zQuTAiLknE_QsUunEXHHUUdF2vgfqVvTkF50dKxHPuFULlvEXGwO7ULQUYTEOVOjgELOgWWPIOeT
 rHkxjDqfBvjVd1ZU5XnACyXGP4vvDSNNl_3UNCgoE7au_rVPeJ5ZeDFCjBsFYm.JPPRjuBuVQrFP
 R5uWjWeam_8KFAaoU6G6hXwQVEhPOsBKmaaYG0v3qFkl5ll6jHKXAS5vv97dTqb4MJO_JJtjZFqJ
 8nqnFoSzCo_hAGRo59Zd_MnwH11A56LuO.FDSyLAEm_sELoq5MrTnw6DhEOTKUdlPO7l_QBJeIfO
 wHGjpw7Svq9ilNSrarWJxDIipjiS_VYMaCgSefQMW7LQA9Vov3vq_zgq6MnI7FMffDV1Eov0HDvM
 Wc6jCGAXmfFOHFxmsulhEwFr_cxphupYFizKXETd_tkWUWaEwZ.6WgE04.1M7C0HCUk.ff_dGTuq
 2dDHFQJzptNiCbUd3G6_M6nWsERmzYfNP4lmuTBKmyq2r3tIYtwo4Qg.1sygS3YGzThkOdKr41pN
 9883Seh2mFmkrliZmSB7L5MVQobHLqZxGNeRVjsuahloDjxu5Vr.MvbXwz9A9NzEdUCmMQ9niHgE
 iQFWgzNk7kxWx4gPgWTZcO1ZTJsEyWh8uC.AQbsQHFxKFMSNP5GjItv5JJ2tCk4.pH2C3z2p7ONU
 0Hv2XNGrjeZGLIUhE1ubBVFDt1dPyzBAzm40sLKPDhtWsJxYWS5Lw_UL0u2pq0E8trkPXEMjZiPy
 NLwp8A8efgzk4xAqhElfRxXlVGi_vDcsGkdZ9MbnhMCdGDoUTfZP24Ye5Wjhsjlp8VftLA63b.c1
 n1vox6.g_ABpZT2zEAdl0KLh_WD4zlqWm.Gp1mmwIFW0s.7DqLOv9TEDa2IFt.Vr0MgkGfDqeHJ9
 QuyeVfmkl1GUDewT1Mdoj791IBzzx9fRKUvCl
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic309.consmr.mail.ne1.yahoo.com with HTTP; Tue, 22 Nov 2022 15:18:30 +0000
Received: by hermes--production-gq1-579bc4bddd-4x2tb (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 11b1f4945ac2a3b0f226371f1ef10484;
          Tue, 22 Nov 2022 15:18:26 +0000 (UTC)
Message-ID: <1afc3928-710e-9b0f-5b0a-cf2cf8d79cb9@schaufler-ca.com>
Date:   Tue, 22 Nov 2022 07:18:24 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [RFC v2 1/1] Use a fs callback to set security specific data
Content-Language: en-US
To:     Joel Granados <j.granados@samsung.com>, mcgrof@kernel.org,
        ddiss@suse.de, joshi.k@samsung.com, paul@paul-moore.com
Cc:     ming.lei@redhat.com, linux-security-module@vger.kernel.org,
        axboe@kernel.dk, io-uring@vger.kernel.org, casey@schaufler-ca.com
References: <20221122103144.960752-1-j.granados@samsung.com>
 <CGME20221122103536eucas1p28f1c88f2300e49942c789721fe70c428@eucas1p2.samsung.com>
 <20221122103144.960752-2-j.granados@samsung.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20221122103144.960752-2-j.granados@samsung.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20863 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 11/22/2022 2:31 AM, Joel Granados wrote:
> Signed-off-by: Joel Granados <j.granados@samsung.com>
> ---
>  drivers/nvme/host/core.c      | 10 ++++++++++
>  include/linux/fs.h            |  2 ++
>  include/linux/lsm_hook_defs.h |  3 ++-
>  include/linux/security.h      | 16 ++++++++++++++--
>  io_uring/uring_cmd.c          |  3 ++-
>  security/security.c           |  5 +++--
>  security/selinux/hooks.c      | 16 +++++++++++++++-
>  7 files changed, 48 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
> index f94b05c585cb..275826fe3c9e 100644
> --- a/drivers/nvme/host/core.c
> +++ b/drivers/nvme/host/core.c
> @@ -4,6 +4,7 @@
>   * Copyright (c) 2011-2014, Intel Corporation.
>   */
>  
> +#include "linux/security.h"
>  #include <linux/blkdev.h>
>  #include <linux/blk-mq.h>
>  #include <linux/blk-integrity.h>
> @@ -3308,6 +3309,13 @@ static int nvme_dev_release(struct inode *inode, struct file *file)
>  	return 0;
>  }
>  
> +int nvme_uring_cmd_sec(struct io_uring_cmd *ioucmd,  struct security_uring_cmd *sec)
> +{
> +	sec->flags = 0;
> +	sec->flags = SECURITY_URING_CMD_TYPE_IOCTL;
> +	return 0;
> +}
> +
>  static const struct file_operations nvme_dev_fops = {
>  	.owner		= THIS_MODULE,
>  	.open		= nvme_dev_open,
> @@ -3315,6 +3323,7 @@ static const struct file_operations nvme_dev_fops = {
>  	.unlocked_ioctl	= nvme_dev_ioctl,
>  	.compat_ioctl	= compat_ptr_ioctl,
>  	.uring_cmd	= nvme_dev_uring_cmd,
> +	.uring_cmd_sec	= nvme_uring_cmd_sec,
>  };
>  
>  static ssize_t nvme_sysfs_reset(struct device *dev,
> @@ -3982,6 +3991,7 @@ static const struct file_operations nvme_ns_chr_fops = {
>  	.compat_ioctl	= compat_ptr_ioctl,
>  	.uring_cmd	= nvme_ns_chr_uring_cmd,
>  	.uring_cmd_iopoll = nvme_ns_chr_uring_cmd_iopoll,
> +	.uring_cmd_sec	= nvme_uring_cmd_sec,
>  };
>  
>  static int nvme_add_ns_cdev(struct nvme_ns *ns)
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index e654435f1651..af743a2dd562 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2091,6 +2091,7 @@ struct dir_context {
>  
>  struct iov_iter;
>  struct io_uring_cmd;
> +struct security_uring_cmd;
>  
>  struct file_operations {
>  	struct module *owner;
> @@ -2136,6 +2137,7 @@ struct file_operations {
>  	int (*uring_cmd)(struct io_uring_cmd *ioucmd, unsigned int issue_flags);
>  	int (*uring_cmd_iopoll)(struct io_uring_cmd *, struct io_comp_batch *,
>  				unsigned int poll_flags);
> +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uring_cmd*);
>  } __randomize_layout;
>  
>  struct inode_operations {
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index ec119da1d89b..6cef29bce373 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -408,5 +408,6 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
>  #ifdef CONFIG_IO_URING
>  LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>  LSM_HOOK(int, 0, uring_sqpoll, void)
> -LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
> +LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd,
> +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uring_cmd*))

I'm slow, and I'm sure the question has been covered elsewhere,
but I have real trouble understanding why you're sending a function
to fetch the security data rather than the data itself. Callbacks
are not usual for LSM interfaces. If multiple security modules have
uring_cmd hooks (e.g. SELinux and landlock) the callback has to be
called multiple times.

>  #endif /* CONFIG_IO_URING */
> diff --git a/include/linux/security.h b/include/linux/security.h
> index ca1b7109c0db..146b1bbdc2e0 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -2065,10 +2065,20 @@ static inline int security_perf_event_write(struct perf_event *event)
>  #endif /* CONFIG_PERF_EVENTS */
>  
>  #ifdef CONFIG_IO_URING
> +enum security_uring_cmd_type
> +{
> +	SECURITY_URING_CMD_TYPE_IOCTL,
> +};
> +
> +struct security_uring_cmd {
> +	u64 flags;
> +};
>  #ifdef CONFIG_SECURITY
>  extern int security_uring_override_creds(const struct cred *new);
>  extern int security_uring_sqpoll(void);
> -extern int security_uring_cmd(struct io_uring_cmd *ioucmd);
> +extern int security_uring_cmd(struct io_uring_cmd *ioucmd,
> +		int (*uring_cmd_sec)(struct io_uring_cmd *,
> +			struct security_uring_cmd*));
>  #else
>  static inline int security_uring_override_creds(const struct cred *new)
>  {
> @@ -2078,7 +2088,9 @@ static inline int security_uring_sqpoll(void)
>  {
>  	return 0;
>  }
> -static inline int security_uring_cmd(struct io_uring_cmd *ioucmd)
> +static inline int security_uring_cmd(struct io_uring_cmd *ioucmd,
> +		int (*uring_cmd_sec)(struct io_uring_cmd *,
> +			struct security_uring_cmd*))
>  {
>  	return 0;
>  }
> diff --git a/io_uring/uring_cmd.c b/io_uring/uring_cmd.c
> index e50de0b6b9f8..2f650b346756 100644
> --- a/io_uring/uring_cmd.c
> +++ b/io_uring/uring_cmd.c
> @@ -108,10 +108,11 @@ int io_uring_cmd(struct io_kiocb *req, unsigned int issue_flags)
>  	struct file *file = req->file;
>  	int ret;
>  
> +	//req->file->f_op->owner->ei_funcs
>  	if (!req->file->f_op->uring_cmd)
>  		return -EOPNOTSUPP;
>  
> -	ret = security_uring_cmd(ioucmd);
> +	ret = security_uring_cmd(ioucmd, req->file->f_op->uring_cmd_sec);
>  	if (ret)
>  		return ret;
>  
> diff --git a/security/security.c b/security/security.c
> index 79d82cb6e469..d3360a32f971 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2667,8 +2667,9 @@ int security_uring_sqpoll(void)
>  {
>  	return call_int_hook(uring_sqpoll, 0);
>  }
> -int security_uring_cmd(struct io_uring_cmd *ioucmd)
> +int security_uring_cmd(struct io_uring_cmd *ioucmd,
> +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uring_cmd*))
>  {
> -	return call_int_hook(uring_cmd, 0, ioucmd);
> +	return call_int_hook(uring_cmd, 0, ioucmd, uring_cmd_sec);
>  }
>  #endif /* CONFIG_IO_URING */
> diff --git a/security/selinux/hooks.c b/security/selinux/hooks.c
> index f553c370397e..9fe3a230c671 100644
> --- a/security/selinux/hooks.c
> +++ b/security/selinux/hooks.c
> @@ -21,6 +21,8 @@
>   *  Copyright (C) 2016 Mellanox Technologies
>   */
>  
> +#include "linux/nvme_ioctl.h"
> +#include "linux/security.h"
>  #include <linux/init.h>
>  #include <linux/kd.h>
>  #include <linux/kernel.h>
> @@ -6999,18 +7001,30 @@ static int selinux_uring_sqpoll(void)
>   * IORING_OP_URING_CMD against the device/file specified in @ioucmd.
>   *
>   */
> -static int selinux_uring_cmd(struct io_uring_cmd *ioucmd)
> +static int selinux_uring_cmd(struct io_uring_cmd *ioucmd,
> +	int (*uring_cmd_sec)(struct io_uring_cmd *ioucmd, struct security_uring_cmd*))
>  {
>  	struct file *file = ioucmd->file;
>  	struct inode *inode = file_inode(file);
>  	struct inode_security_struct *isec = selinux_inode(inode);
>  	struct common_audit_data ad;
> +	const struct cred *cred = current_cred();
> +	struct security_uring_cmd sec_uring = {0};
> +	int ret;
>  
>  	ad.type = LSM_AUDIT_DATA_FILE;
>  	ad.u.file = file;
>  
> +	ret = uring_cmd_sec(ioucmd, &sec_uring);
> +	if (ret)
> +		return ret;
> +
> +	if (sec_uring.flags & SECURITY_URING_CMD_TYPE_IOCTL)
> +		return ioctl_has_perm(cred, file, FILE__IOCTL, (u16) ioucmd->cmd_op);
> +
>  	return avc_has_perm(&selinux_state, current_sid(), isec->sid,
>  			    SECCLASS_IO_URING, IO_URING__CMD, &ad);
> +
>  }
>  #endif /* CONFIG_IO_URING */
>  
