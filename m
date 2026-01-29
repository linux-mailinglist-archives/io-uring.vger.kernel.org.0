Return-Path: <io-uring+bounces-11975-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id UMbRJsDHe2nZIQIAu9opvQ
	(envelope-from <io-uring+bounces-11975-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:49:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 0440CB459E
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 21:49:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id B8B5E301570B
	for <lists+io-uring@lfdr.de>; Thu, 29 Jan 2026 20:49:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA93834DCD6;
	Thu, 29 Jan 2026 20:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="g0zepfp7"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9E8D325494
	for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 20:48:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769719741; cv=pass; b=SgxkUvKHji4yR0f5g+HhL1rXG5Wov3zzy/3uaLXPgIx3XydojbPtPXIqbSJ9ahqjfzBPt4IgcvcWGZf7BP4vzRIdnRvTjbnIFNGyjj8ZpsUIoBgtC9ukVS9ROm/2bBEgZmR0TtKSM+S7FK1n72J/gw2PgeeCbllCutqH+6lpiJA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769719741; c=relaxed/simple;
	bh=fwCNYL36fmNidWxTRLLQoPY4jYAs7whYoElU8NHIA0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=efYxemKRVcgYpxMXH1fRMD+/KZa/ud4jkn/QBXdlVKt/xOr97IKHGZowY1jjcA5GB3LeMSz1kEBtaahRoL3hmPvzCvZMlIR1GzvrUKLWaapCZCnaSWS+pYhmedboUZNOJPYUKAUxDFioZU4L/XEp1i2rVMOQpk+86PR5sB4ccmY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=g0zepfp7; arc=pass smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7d1739b6cc5so317154a34.2
        for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 12:48:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769719739; cv=none;
        d=google.com; s=arc-20240605;
        b=GVGiVb10RcwCkeT4kvDTIFiBUhcPC9mrwu8fi3OH+DXLAIWLQ4RnhXUmK0rGGx2Iat
         NV2hIaOPqOOKUGIBi+SWcEV021TJAQY9dED9jKriixqNrNqcU/Oi5gVX9T+AuwezRxss
         JYspoD6TMIV0qTPVcTssyZgLLIMP0lOh+3Zta8axEUwic5w99QYHUjLyLN+by2jczFp7
         gebDVoIBOP2TOggUJ+yw8+JzkpWrXyoCbS1rACjpn0QlNUdrClvnLuazsmzNDJpGig4C
         em7m6cRc0SM1WTg8jC3DeaYCxRPOKNtMScDUlizyu1rq1wQjnkyws19KpXG432sjOobA
         6aWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=YKJtXTMDcuXMAPGG/e6MtBrIwENHi/GJ4bDU5+XzD3Y=;
        fh=vGBN8Zi+4pNLgbYV4Ttk/7tHrAXTaf1fin8+DqzFQeM=;
        b=G1OtfdJUvT7513+87WCAyxQPFFoNJqMH1rRFZ4K7Kd3WJZ3CfZzxybAU/vFUuL+S+n
         2+eakG6OZnAs4Uj6CdpEkTBhLVQW9cG04q9vp9WV/PaYCPhk0yc9ggaFflxu6VxZEmyF
         IPKK2InZRRJr+YRqn96kdakWPFii/T3UMn26zjzIZIVzx6HcRUGiP0haTkRRhzQHL/qc
         qhZ+l7VRl8Z16TZWMzG/pyfro6u4QF7V35LOtLJcmMJPcyI3SbHxjmg+dEzgahRt0X32
         ENvjkeAW3tRBR7ULGsAiilwqHpnBEcAvsdd3WLHf6ZbMoCF3erCpqtLWlBO8rwi5l7UH
         0I4w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1769719739; x=1770324539; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YKJtXTMDcuXMAPGG/e6MtBrIwENHi/GJ4bDU5+XzD3Y=;
        b=g0zepfp7RBDy6gkfXxQeKgCF/vHMMQqiXyaWbh7dAVpVgDsmVBhZRiaHhCNfJ1+f3s
         /2uEuilMedFqTW6Q3zy2imS6JGktynyHx3GIExfcEqzsPU7j4KwOAF3XdycQ/QROIdy6
         2KjrDZKAZTE0w/ZiFZXXmzLByOMc9Fbk4Tux3pdTv7SyHowgAxjZplU68LIQHZG0s+3M
         8fnTbw0JYRTnHP0d7btl7GeqmAKcuh7mr624gSugyNSOGoSsErxY5DRpyLKKdQg+r3CB
         ZHMMUe7ifVAQGz/h3BfTrN+ixsQFUiaa5ysGVoat4slwA3pTva24ZKwkE8jW7wDlNjWI
         87fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769719739; x=1770324539;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=YKJtXTMDcuXMAPGG/e6MtBrIwENHi/GJ4bDU5+XzD3Y=;
        b=tMbWPshT/ncBY/IR3LnvnnCGGo5gVw59TFlFjBJAnNcP3AkYLQBIeOTbRV7h+ehnDe
         jRmYS+oaKmLcCtq7xWUFPQebfTSSXjsY3aUSFtyh6kiklyf6LAvbW1BKL5qxJ0yj7OK8
         GvBbWpaLL+IXamCyVGwIwFIaEuDcuCdp9RPNX24GuxUVdrickKQ5nD98KAvlDH+zfFeP
         UmERDz2w/rjGjjZyp16B4JMryqxha6/jP9M5+wTQqP/Zddpt23vIOaKXWnW64b7/5i6I
         Ch7I4Lmr7Ubpc0Za7gFT8HLaZKnpyc4luaBVtGefz5Vn6Qws0yqpnV5kFJ7DSgbLlgMK
         gmvw==
X-Gm-Message-State: AOJu0YzajLO6f28Zo3pBmjgDocWfbQFCjes4tUE9v98R4svh8erfP5r7
	S0hy7rK2K3HmHHQSY38LVJ+WXIWDOfCvqOmMKrrXxRNiUjv4gEVAhVIr+96cQlYI+KCq0F+aOH0
	C1bDtDUScM33Oc/rpUKuG9pqLvg4CK+gWGkt6Nto1ig==
X-Gm-Gg: AZuq6aIrW0MDn51sj//1qslZPWI09e4nLw2KyauAoBqsqFlIncaUrKLN318N4DVdGm6
	DfwCfRiMrNv8DBnQaeWFn5FEy+Qdt8GzD+nWDlKb547TW4ifBfdPlr9oOL9LJ3xDUmFVSsvs488
	RI8+odZpjukVmnHT6oDr+VclZ4kJdRaeu70juvr6IPu+D8PwQR1JJqtpDh9QNBrDRQ7ruy1L2EY
	vvfe1wASMUmfVWomCYJLw9YSzVUfspJzm2z9G+JtcAyOCKVAZqW6TiB74K+YM/GZCIj5N38Wo7w
	Jb4MuQ==
X-Received: by 2002:a05:6830:43a1:b0:7cf:da36:3d3d with SMTP id
 46e09a7af769-7d1a536e341mr465115a34.6.1769719738611; Thu, 29 Jan 2026
 12:48:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129201347.411015-1-govind.varadar@gmail.com> <20260129201347.411015-2-govind.varadar@gmail.com>
In-Reply-To: <20260129201347.411015-2-govind.varadar@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 29 Jan 2026 12:48:47 -0800
X-Gm-Features: AZwV_QjzuriaOysLvS44pSe_C_oijO9lNrjQKfR9zwyYW5mmEwJyCNqpzpZ0JVQ
Message-ID: <CADUfDZoxS1uOCNd+WdZ12N2foq+jLMcuyzKNrzB_LS0S7p82sw@mail.gmail.com>
Subject: Re: [PATCH 1/2] io_uring: Add size check for sqe->cmd
To: Govindarajulu Varadarajan <govind.varadar@gmail.com>
Cc: io-uring@vger.kernel.org, axboe@kernel.dk, ming.lei@redhat.com, 
	kbusch@kernel.org, hch@lst.de, sagi@grimberg.me, miklos@szeredi.hu
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=2];
	DMARC_POLICY_ALLOW(-0.50)[purestorage.com,reject];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11975-lists,io-uring=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FREEMAIL_TO(0.00)[gmail.com];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TAGGED_RCPT(0.00)[io-uring];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 0440CB459E
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 12:14=E2=80=AFPM Govindarajulu Varadarajan
<govind.varadar@gmail.com> wrote:
>
> For SQE128, sqe->cmd provides 80 bytes for uring_cmd. Add macro to
> check if size of user struct does not exceed 80 bytes at compile time.
> User doesn't have to track this manually during development.
>
> Replace io_uring_sqe_cmd() with IO_URING_SQE_CMD() which checks struct
> size for 16 bytes cmd.
>
> Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
> ---
>  drivers/block/ublk_drv.c     | 14 ++++++++------
>  drivers/nvme/host/ioctl.c    |  2 +-
>  fs/fuse/dev_uring.c          |  6 ++++--
>  include/linux/io_uring/cmd.h | 15 +++++++++++----
>  4 files changed, 24 insertions(+), 13 deletions(-)
>
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 4265b7610c95..7c8a23709efa 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -3155,7 +3155,7 @@ static int ublk_ch_uring_cmd_local(struct io_uring_=
cmd *cmd,
>                 unsigned int issue_flags)
>  {
>         /* May point to userspace-mapped memory */
> -       const struct ublksrv_io_cmd *ub_src =3D io_uring_sqe_cmd(cmd->sqe=
);
> +       const struct ublksrv_io_cmd *ub_src =3D IO_URING_SQE_CMD(cmd->sqe=
, struct ublksrv_io_cmd);
>         u16 buf_idx =3D UBLK_INVALID_BUF_IDX;
>         struct ublk_device *ub =3D cmd->file->private_data;
>         struct ublk_queue *ubq;
> @@ -3735,7 +3735,7 @@ static int ublk_validate_batch_fetch_cmd(struct ubl=
k_batch_io_data *data)
>  static int ublk_handle_non_batch_cmd(struct io_uring_cmd *cmd,
>                                      unsigned int issue_flags)
>  {
> -       const struct ublksrv_io_cmd *ub_cmd =3D io_uring_sqe_cmd(cmd->sqe=
);
> +       const struct ublksrv_io_cmd *ub_cmd =3D IO_URING_SQE_CMD(cmd->sqe=
, struct ublksrv_io_cmd);
>         struct ublk_device *ub =3D cmd->file->private_data;
>         unsigned tag =3D READ_ONCE(ub_cmd->tag);
>         unsigned q_id =3D READ_ONCE(ub_cmd->q_id);
> @@ -3764,7 +3764,7 @@ static int ublk_handle_non_batch_cmd(struct io_urin=
g_cmd *cmd,
>  static int ublk_ch_batch_io_uring_cmd(struct io_uring_cmd *cmd,
>                                        unsigned int issue_flags)
>  {
> -       const struct ublk_batch_io *uc =3D io_uring_sqe_cmd(cmd->sqe);
> +       const struct ublk_batch_io *uc =3D IO_URING_SQE_CMD(cmd->sqe, str=
uct ublk_batch_io);
>         struct ublk_device *ub =3D cmd->file->private_data;
>         struct ublk_batch_io_data data =3D {
>                 .ub  =3D ub,
> @@ -4653,7 +4653,8 @@ static int ublk_ctrl_del_dev(struct ublk_device **p=
_ub, bool wait)
>
>  static inline void ublk_ctrl_cmd_dump(struct io_uring_cmd *cmd)
>  {
> -       const struct ublksrv_ctrl_cmd *header =3D io_uring_sqe_cmd(cmd->s=
qe);
> +       const struct ublksrv_ctrl_cmd *header =3D IO_URING_SQE128_CMD(cmd=
->sqe,
> +                                                                   struc=
t ublksrv_ctrl_cmd);
>
>         pr_devel("%s: cmd_op %x, dev id %d qid %d data %llx buf %llx len =
%u\n",
>                         __func__, cmd->cmd_op, header->dev_id, header->qu=
eue_id,
> @@ -5061,7 +5062,7 @@ static int ublk_char_dev_permission(struct ublk_dev=
ice *ub,
>  static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
>                 struct io_uring_cmd *cmd)
>  {
> -       struct ublksrv_ctrl_cmd *header =3D (struct ublksrv_ctrl_cmd *)io=
_uring_sqe_cmd(cmd->sqe);
> +       struct ublksrv_ctrl_cmd *header =3D IO_URING_SQE128_CMD(cmd->sqe,=
 struct ublksrv_ctrl_cmd);
>         bool unprivileged =3D ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DE=
V;
>         void __user *argp =3D (void __user *)(unsigned long)header->addr;
>         char *dev_path =3D NULL;
> @@ -5152,7 +5153,8 @@ static bool ublk_ctrl_uring_cmd_may_sleep(u32 cmd_o=
p)
>  static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
>                 unsigned int issue_flags)
>  {
> -       const struct ublksrv_ctrl_cmd *header =3D io_uring_sqe_cmd(cmd->s=
qe);
> +       const struct ublksrv_ctrl_cmd *header =3D IO_URING_SQE128_CMD(cmd=
->sqe,
> +                                                                   struc=
t ublksrv_ctrl_cmd);
>         struct ublk_device *ub =3D NULL;
>         u32 cmd_op =3D cmd->cmd_op;
>         int ret =3D -EINVAL;
> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index fb62633ccbb0..90c49bb727ad 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c
> @@ -447,7 +447,7 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, =
struct nvme_ns *ns,
>                 struct io_uring_cmd *ioucmd, unsigned int issue_flags, bo=
ol vec)
>  {
>         struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
> -       const struct nvme_uring_cmd *cmd =3D io_uring_sqe_cmd(ioucmd->sqe=
);
> +       const struct nvme_uring_cmd *cmd =3D IO_URING_SQE128_CMD(ioucmd->=
sqe, struct nvme_uring_cmd);

Some of these lines are quite long

>         struct request_queue *q =3D ns ? ns->queue : ctrl->admin_q;
>         struct nvme_uring_data d;
>         struct nvme_command c;
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index 5ceb217ced1b..7dddba72f406 100644
> --- a/fs/fuse/dev_uring.c
> +++ b/fs/fuse/dev_uring.c
> @@ -879,7 +879,8 @@ static int fuse_ring_ent_set_commit(struct fuse_ring_=
ent *ent)
>  static int fuse_uring_commit_fetch(struct io_uring_cmd *cmd, int issue_f=
lags,
>                                    struct fuse_conn *fc)
>  {
> -       const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe_cmd(cmd=
->sqe);
> +       const struct fuse_uring_cmd_req *cmd_req =3D IO_URING_SQE128_CMD(=
cmd->sqe,
> +                                                                      st=
ruct fuse_uring_cmd_req);
>         struct fuse_ring_ent *ent;
>         int err;
>         struct fuse_ring *ring =3D fc->ring;
> @@ -1083,7 +1084,8 @@ fuse_uring_create_ring_ent(struct io_uring_cmd *cmd=
,
>  static int fuse_uring_register(struct io_uring_cmd *cmd,
>                                unsigned int issue_flags, struct fuse_conn=
 *fc)
>  {
> -       const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe_cmd(cmd=
->sqe);
> +       const struct fuse_uring_cmd_req *cmd_req =3D IO_URING_SQE128_CMD(=
cmd->sqe,
> +                                                                      st=
ruct fuse_uring_cmd_req);
>         struct fuse_ring *ring =3D smp_load_acquire(&fc->ring);
>         struct fuse_ring_queue *queue;
>         struct fuse_ring_ent *ent;
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 375fd048c4cb..e8fd93e90cde 100644
> --- a/include/linux/io_uring/cmd.h
> +++ b/include/linux/io_uring/cmd.h
> @@ -20,10 +20,17 @@ struct io_uring_cmd {
>         u8              unused[8];
>  };
>
> -static inline const void *io_uring_sqe_cmd(const struct io_uring_sqe *sq=
e)
> -{
> -       return sqe->cmd;
> -}
> +#define IO_URING_SQE128_CMD(sqe, type) ({                               =
               \
> +       BUILD_BUG_ON(sizeof(type) > ((2 * sizeof(struct io_uring_sqe)) - =
               \
> +                                    offsetof(struct io_uring_sqe, cmd)))=
;              \
> +       (type *)(sqe)->cmd;                                              =
               \
> +})
> +
> +#define IO_URING_SQE_CMD(sqe, type)    ({                               =
               \
> +       BUILD_BUG_ON(sizeof(type) > ((sizeof(struct io_uring_sqe)) -     =
               \
> +                                    offsetof(struct io_uring_sqe, cmd)))=
;              \
> +       (type *)(sqe)->cmd;

Can we continue to return a const pointer? It would be buggy for a
uring_cmd implementation to write to the the io_uring_sqe, which may
live in userspace-mapped memory.

Best,
Caleb

                                                        \
> +})
>
>  static inline void io_uring_cmd_private_sz_check(size_t cmd_sz)
>  {
> --
> 2.52.0
>
>

