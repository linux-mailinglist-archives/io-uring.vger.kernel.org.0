Return-Path: <io-uring+bounces-11983-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id QnUFKSQJfGn1KAIAu9opvQ
	(envelope-from <io-uring+bounces-11983-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 02:28:04 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id ED1D5B6276
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 02:28:03 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 850B6300DF75
	for <lists+io-uring@lfdr.de>; Fri, 30 Jan 2026 01:28:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA68832F762;
	Fri, 30 Jan 2026 01:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="D2VVZBhE"
X-Original-To: io-uring@vger.kernel.org
Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01CBC215F42
	for <io-uring@vger.kernel.org>; Fri, 30 Jan 2026 01:27:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769736481; cv=pass; b=JyJ328VZ7ou2h77id18SlmbPU7bMCokASLatH1HQbzFV94vD1BpgRE2HnaFGqZ+AsfkVTVx3pGPGzwvW4+bdsFz/NbD6bPbxIVzaSwsvGbnR1pio2XCanoHWPHBZn5nZHOJ00N3TU71b087gzNuGtS3UKXmI8yE94yC3Bxu5Qww=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769736481; c=relaxed/simple;
	bh=DuoLvIi0WNhAyWaLzyx7hRL/edQhk/zQmwqYHsEzZmo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g4ST5HoqzsdvUqXQUaTHfMBWmHmugtqrM/aubHyXn0i/7DgFqdThTdzTWuGo9H64m02PVf5uO9ghIkqno2wOwmcQsZHFp6K0vU6BY0nzFASclOQ7f00EVVFSswshYjCsELMzLwdx9eeVOZ5w84jq6hFydlEpqfxIoESfGACRJDo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=D2VVZBhE; arc=pass smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-662f4fd7e5fso3239eaf.3
        for <io-uring@vger.kernel.org>; Thu, 29 Jan 2026 17:27:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769736479; cv=none;
        d=google.com; s=arc-20240605;
        b=TjH62ANtdoKsruRzacOZo2bG1AHY/nL3yKqKCnmsl7Bf9MxmmV2aDleirQvT7q90bZ
         4FMEuDIhk2LTFT5v1CirYX0kMFB9P21gD3dFXX+J9l+lND2NqZSYClQS5mZyZJMIC4Yi
         gpYF1h+EeQRaWyJapKM2LoHBuIeafTo5BPvMOz8QIQtshUCeTUCHz4JaKAH14gIL+snW
         4CeiB1fItD+Y7OXB9aei8LF5n5XEm4lN4xQBq1lU6hdHBW65IOs2SFW+c4+DIeaXxrfa
         H5T5vQEa9MMjQsNMkIRJkU9Elcf4A6rxFmxxikaGdMRKIcQwQK7r9Rs+bJK+VSzUxQGo
         FFCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vKOgYWnCPW1aZ9iVbJtaOQkjpJq9DV1UvYwbgofVVQQ=;
        fh=vGBN8Zi+4pNLgbYV4Ttk/7tHrAXTaf1fin8+DqzFQeM=;
        b=WcJEvMtghjJ/ycRIwCZR13ZdHlvlXl1GZFODS7sqM0rTTRXk+w/hxLp/6fCIvVhWNc
         Lnl8KNBDXbsyKKfViYfsVMPAIG+VOfbKYCCUI1FjW3nU6F7RwNsKXFJfnjmrfmERXOYF
         4ty20TbNYlHVZP/9scdDBRoWA132qVwYdBNo3m5daKxE+c9JWs6zRlt8DEAM0PyIG8iD
         ZvMVbYupF/duBXUlbgweTdu/jrj0JD1WuTIO17cjKSSXWS3MIRjmwHudwCiCAYh/DjS6
         XusyNTdD3evPggE6AOwJGKbzJX958Pn3fhAc5NsHrngKYx/dpB6nPGHzszr2lJr+Kypg
         IVtw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1769736479; x=1770341279; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vKOgYWnCPW1aZ9iVbJtaOQkjpJq9DV1UvYwbgofVVQQ=;
        b=D2VVZBhEk2ytQM3xR7Uf8rFTow/zy5eiwE5dF7QcLXCskXAECynuAftQsUfAVg7FWn
         6oRTqsnrinjGqJleEBkhDGY3Dk6yXY8QLHxa0NdXQ3jF38tko4fwVYG7ery2FnLOYvSK
         2MxrRDQBCKy5RDU71iCzlQXz+ajK6j/ax1y5WE8KxD3hr4T3Rs/vkHBV4XY7E5orl8Ox
         Hu95Eisx8v0Fuo7BD44hZVQMaZLvpbZh1THeVw/OaqdBkG8o1phmv3FPERLMQiDDf/PL
         dpHswQtUmYRd7DbJzi4jK4NlC74N5O6+AWjZplc4/3RE8AaSa8VZLJ3IAXUT/Pzstuwg
         a0Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769736479; x=1770341279;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=vKOgYWnCPW1aZ9iVbJtaOQkjpJq9DV1UvYwbgofVVQQ=;
        b=LxF3IixQWSkfHoycxq0XRWr193VFR1lULiOMPjINJeUi6e+qQBKQuoGDWjnDtH8JjI
         XWy2livnthFb4Z5KotKrhcXxsI2kvRezeAjphWxbcfGwyWS9SfylJa2aW3lrQNdc+XbL
         J6e/AnN4OHL4ZodOCJXPH9U+VwnhDnVFUF4awmYYohW6z4s8w/qDfzPKRpdVoumWvvKf
         QciZHI4NZ9Bp70vhPSk5QQgnJciM3MHQ74N3JUJ8WW1yRVn7v8vFdrSXJCzsFS+DiweS
         frkDQ4CTNKvdqk7fd2CUD74C7zrubuzEb/qSH9gBzOV4no1jGfEkVF3UWBZ+r+PvjPZa
         lVRA==
X-Gm-Message-State: AOJu0YxS5WieJYcsRmuU4ffVhLMJ/aphBl8DKEaiRJWHKRFl2+kRJY95
	boEVMqhsefVoIDvDsNAIR44L8sbFZrLB1sKEsbFz1mnMrQD7ij0fCWo1MR2Olvuvc9TsDivc8mJ
	5+xe60cJedC0Sw/F+0RL+jVwfk3KdFGk7XiQo74NoLQ==
X-Gm-Gg: AZuq6aLyfpqt1yXshgJ5m76ke/B67rQ7db2EEmViiyH0z1ORB0jy+3Fu87KFe6st+04
	+RQPIMyl1milZNmyAPcZj+KRolkZCBIe8oR0i2JVE5IvAQIHP66WI74hjKmKVKMDvNU9VsD7NrI
	Si0ykJuTj2bZFL7OSff0Xhkk5t/hKxbZMef4vYkJepElR7iyAgT5TknXK3bfluYgZNCLex1yxJK
	xAF4BUmW9IQu/Bw+ASrxBSkVXC2yol+DIeWfe/y7bybMcDU8bImxFQ4VT7Rsr3SPtCsyihA
X-Received: by 2002:a4a:ce99:0:b0:662:dab9:f94c with SMTP id
 006d021491bc7-6630ef4052bmr409986eaf.0.1769736478591; Thu, 29 Jan 2026
 17:27:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260129235434.418973-1-govind.varadar@gmail.com>
In-Reply-To: <20260129235434.418973-1-govind.varadar@gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 29 Jan 2026 17:27:48 -0800
X-Gm-Features: AZwV_QiLEuvZSq60UVXZK6M2vJRIY4dJWIHZAC0UQZXcrQLCjgrP15c1qH4XV_s
Message-ID: <CADUfDZocbHofja6OTwsn7AZrYiqO=Osm=4ED4d2yd3_7Jv2-gA@mail.gmail.com>
Subject: Re: [PATCH v2] io_uring: Add size check for sqe->cmd
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[purestorage.com:s=google2022];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-11983-lists,io-uring=lfdr.de];
	FREEMAIL_TO(0.00)[gmail.com];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2600:3c0a:e001:db::12fc:5321:from];
	RCVD_COUNT_THREE(0.00)[4];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FROM_HAS_DN(0.00)[];
	MISSING_XM_UA(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[csander@purestorage.com,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[purestorage.com:+];
	RCPT_COUNT_SEVEN(0.00)[8];
	TAGGED_RCPT(0.00)[io-uring];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[100.90.174.1:received,209.85.161.44:received];
	TO_DN_SOME(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[mail.gmail.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,purestorage.com:email,purestorage.com:dkim]
X-Rspamd-Queue-Id: ED1D5B6276
X-Rspamd-Action: no action

On Thu, Jan 29, 2026 at 3:55=E2=80=AFPM Govindarajulu Varadarajan
<govind.varadar@gmail.com> wrote:
>
> For SQE128, sqe->cmd provides 80 bytes for uring_cmd. Add macro to
> check if size of user struct does not exceed 80 bytes at compile time.
> User doesn't have to track this manually during development.
>
> Replace io_uring_sqe_cmd() inline func with macro and add
> io_uring_sqe128_cmd() which checks struct
> size for 16 bytes cmd and 80 bytes cmd respectively.
>
> Signed-off-by: Govindarajulu Varadarajan <govind.varadar@gmail.com>
> ---
> v2:
>   - Replace all caps macro with lower case definition.
>   - Add const qualifier to return type.
>   - Rebase on top of series "[PATCH 0/4] ublk: fix struct
>     ublksrv_ctrl_cmd accesses"
>
> BRANCH: for-7.0/block
>
> Depends-on series: "[PATCH 0/4] ublk: fix struct ublksrv_ctrl_cmd
> accesses"
>   Needs "[PATCH 2/4] ublk: don't write to struct ublksrv_ctrl_cmd" to
>   avoid merge conflict.
> ---
>  drivers/block/ublk_drv.c     | 14 +++++++++-----
>  drivers/nvme/host/ioctl.c    |  3 ++-
>  fs/fuse/dev_uring.c          |  6 ++++--
>  include/linux/io_uring/cmd.h | 15 +++++++++++----
>  4 files changed, 26 insertions(+), 12 deletions(-)
>
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index 0e25a59849ae..3f9d6dc3afef 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
> @@ -3244,7 +3244,8 @@ static int ublk_ch_uring_cmd_local(struct io_uring_=
cmd *cmd,
>                 unsigned int issue_flags)
>  {
>         /* May point to userspace-mapped memory */
> -       const struct ublksrv_io_cmd *ub_src =3D io_uring_sqe_cmd(cmd->sqe=
);
> +       const struct ublksrv_io_cmd *ub_src =3D io_uring_sqe_cmd(cmd->sqe=
,
> +                                                              struct ubl=
ksrv_io_cmd);
>         u16 buf_idx =3D UBLK_INVALID_BUF_IDX;
>         struct ublk_device *ub =3D cmd->file->private_data;
>         struct ublk_queue *ubq;
> @@ -3824,7 +3825,8 @@ static int ublk_validate_batch_fetch_cmd(struct ubl=
k_batch_io_data *data)
>  static int ublk_handle_non_batch_cmd(struct io_uring_cmd *cmd,
>                                      unsigned int issue_flags)
>  {
> -       const struct ublksrv_io_cmd *ub_cmd =3D io_uring_sqe_cmd(cmd->sqe=
);
> +       const struct ublksrv_io_cmd *ub_cmd =3D io_uring_sqe_cmd(cmd->sqe=
,
> +                                                              struct ubl=
ksrv_io_cmd);
>         struct ublk_device *ub =3D cmd->file->private_data;
>         unsigned tag =3D READ_ONCE(ub_cmd->tag);
>         unsigned q_id =3D READ_ONCE(ub_cmd->q_id);
> @@ -3853,7 +3855,7 @@ static int ublk_handle_non_batch_cmd(struct io_urin=
g_cmd *cmd,
>  static int ublk_ch_batch_io_uring_cmd(struct io_uring_cmd *cmd,
>                                        unsigned int issue_flags)
>  {
> -       const struct ublk_batch_io *uc =3D io_uring_sqe_cmd(cmd->sqe);
> +       const struct ublk_batch_io *uc =3D io_uring_sqe_cmd(cmd->sqe, str=
uct ublk_batch_io);
>         struct ublk_device *ub =3D cmd->file->private_data;
>         struct ublk_batch_io_data data =3D {
>                 .ub  =3D ub,
> @@ -5106,7 +5108,8 @@ static int ublk_char_dev_permission(struct ublk_dev=
ice *ub,
>  static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
>                 struct io_uring_cmd *cmd, u64 *addr, u16 *len)
>  {
> -       const struct ublksrv_ctrl_cmd *header =3D io_uring_sqe_cmd(cmd->s=
qe);
> +       const struct ublksrv_ctrl_cmd *header =3D io_uring_sqe128_cmd(cmd=
->sqe,
> +                                                                   struc=
t ublksrv_ctrl_cmd);
>         bool unprivileged =3D ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DE=
V;
>         void __user *argp =3D (void __user *)*addr;
>         char *dev_path =3D NULL;
> @@ -5199,7 +5202,8 @@ static bool ublk_ctrl_uring_cmd_may_sleep(u32 cmd_o=
p)
>  static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
>                 unsigned int issue_flags)
>  {
> -       const struct ublksrv_ctrl_cmd *header =3D io_uring_sqe_cmd(cmd->s=
qe);
> +       const struct ublksrv_ctrl_cmd *header =3D io_uring_sqe128_cmd(cmd=
->sqe,
> +                                                                   struc=
t ublksrv_ctrl_cmd);
>         struct ublk_device *ub =3D NULL;
>         u32 cmd_op =3D cmd->cmd_op;
>         int ret =3D -EINVAL;
> diff --git a/drivers/nvme/host/ioctl.c b/drivers/nvme/host/ioctl.c
> index fb62633ccbb0..8844bbd39515 100644
> --- a/drivers/nvme/host/ioctl.c
> +++ b/drivers/nvme/host/ioctl.c
> @@ -447,7 +447,8 @@ static int nvme_uring_cmd_io(struct nvme_ctrl *ctrl, =
struct nvme_ns *ns,
>                 struct io_uring_cmd *ioucmd, unsigned int issue_flags, bo=
ol vec)
>  {
>         struct nvme_uring_cmd_pdu *pdu =3D nvme_uring_cmd_pdu(ioucmd);
> -       const struct nvme_uring_cmd *cmd =3D io_uring_sqe_cmd(ioucmd->sqe=
);
> +       const struct nvme_uring_cmd *cmd =3D io_uring_sqe128_cmd(ioucmd->=
sqe,
> +                                                              struct nvm=
e_uring_cmd);
>         struct request_queue *q =3D ns ? ns->queue : ctrl->admin_q;
>         struct nvme_uring_data d;
>         struct nvme_command c;
> diff --git a/fs/fuse/dev_uring.c b/fs/fuse/dev_uring.c
> index 5ceb217ced1b..60f2058feb74 100644
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
> +       const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe128_cmd(=
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
> +       const struct fuse_uring_cmd_req *cmd_req =3D io_uring_sqe128_cmd(=
cmd->sqe,
> +                                                                      st=
ruct fuse_uring_cmd_req);
>         struct fuse_ring *ring =3D smp_load_acquire(&fc->ring);
>         struct fuse_ring_queue *queue;
>         struct fuse_ring_ent *ent;
> diff --git a/include/linux/io_uring/cmd.h b/include/linux/io_uring/cmd.h
> index 375fd048c4cb..7245b975c55d 100644
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
> +#define io_uring_sqe128_cmd(sqe, type) ({                               =
       \
> +       BUILD_BUG_ON(sizeof(type) > ((2 * sizeof(struct io_uring_sqe)) - =
       \
> +                                    offsetof(struct io_uring_sqe, cmd)))=
;      \
> +       (const type *)(sqe)->cmd;                                        =
       \
> +})
> +
> +#define io_uring_sqe_cmd(sqe, type)    ({                               =
       \
> +       BUILD_BUG_ON(sizeof(type) > ((sizeof(struct io_uring_sqe)) -     =
       \

Could remove the extra set of parens around sizeof(struct io_uring_sqe).

Other than that,
Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>

> +                                    offsetof(struct io_uring_sqe, cmd)))=
;      \
> +       (const type *)(sqe)->cmd;                                        =
       \
> +})
>
>  static inline void io_uring_cmd_private_sz_check(size_t cmd_sz)
>  {
> --
> 2.52.0
>
>

