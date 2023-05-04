Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57ED66F6D75
	for <lists+io-uring@lfdr.de>; Thu,  4 May 2023 16:04:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbjEDOEe (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Thu, 4 May 2023 10:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbjEDOEd (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Thu, 4 May 2023 10:04:33 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4128C76B7;
        Thu,  4 May 2023 07:04:32 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id 4fb4d7f45d1cf-50bcb229adaso1013115a12.2;
        Thu, 04 May 2023 07:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1683209071; x=1685801071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3vGEbVb2Iw1e256eidlQkAuPtncWcP3UfFonkvYXZLg=;
        b=Nk+xPWMPNalhn1FRh11ReONk3sQr57APGlwmvlRIpnAVvqCEDpTJMY4vc+6MkbGMra
         GDYZ55GPmTq9h6Ec2fTWUT/XOK5vQ1jiJfWBe5epBkjAEdvi1eiOQ2tJFAzORNAngE/K
         wLR3V45p7/udMtvKjzlQLBUKJ4LK9ctUJxAjN1di9wfupdSSasbqkHMkCYz5tvDlN5GC
         PwQuMauFX8sdf/ao5Nx3Puq3KGUuNVW/GPGUqw7ZO34xDuIkBAgMEuWGfYlfHur/k+Nq
         Ygg5B+sH4iuqLHw2RVRsQ9GwZvtQIfhy+6Tb2uPa9up+6O5VXOJcBRPu06BqMJuGzZh9
         YPMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683209071; x=1685801071;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3vGEbVb2Iw1e256eidlQkAuPtncWcP3UfFonkvYXZLg=;
        b=YSrg606N+VZbCP6MVDm/hgqt09mVe7u47PhhMkBt/E3xZRU2oKE6M+KvE9rhtE8Lqt
         JObFjHfIDo+SsgxwvkQvS7bKveMxOvGPKpzmzfe7MTLS7CdwLaG51M5OOM3kaeCd6JXf
         blCZa5qw7ra0J+cqjRE2h6oyu3a0Or+QEmkGsX7eZMzKtjzOjS0UF3pihD72leSAFwd8
         qtBbzeJiNbOuHjsHPEqh6bWM0gIrz4FwmRCwkqgipyFHwrqLe/jS/syLTRw3oy9U6crH
         eVKBNaGop7fHY6DXwXf9tSlo7eHcoUxN/65tqIyZ4mn47XLD2ms5cqz5fpqRXhhk8SOm
         Mi5Q==
X-Gm-Message-State: AC+VfDxlNuHrwoEFtfT9niw5pAF0mqqu5D3VCSUnRN5c9OrOW/RX4TI6
        gvnkJzO0mSVrUbduInrLJKU=
X-Google-Smtp-Source: ACHHUZ4yEGLnlFZ2fGf6X+WKdesQczN5NZzLP+f4vTvEWOifinJDMwQt72frXvh2DTuC2jQCxBQzBQ==
X-Received: by 2002:a17:907:3202:b0:957:278c:fb27 with SMTP id xg2-20020a170907320200b00957278cfb27mr5703358ejb.21.1683209070439;
        Thu, 04 May 2023 07:04:30 -0700 (PDT)
Received: from ?IPV6:2620:10d:c096:310::20ef? ([2620:10d:c092:600::2:1631])
        by smtp.gmail.com with ESMTPSA id s17-20020a170906285100b0094e597f0e4dsm18578597ejc.121.2023.05.04.07.04.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 04 May 2023 07:04:30 -0700 (PDT)
Message-ID: <b32d275b-bb7a-4090-1d13-945ffca63c91@gmail.com>
Date:   Thu, 4 May 2023 15:04:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH v4 2/3] io_uring: Pass whole sqe to commands
Content-Language: en-US
To:     Breno Leitao <leitao@debian.org>, io-uring@vger.kernel.org,
        linux-nvme@lists.infradead.org, hch@lst.de, axboe@kernel.dk,
        ming.lei@redhat.com
Cc:     leit@fb.com, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, sagi@grimberg.me, joshi.k@samsung.com,
        kbusch@kernel.org
References: <20230504121856.904491-1-leitao@debian.org>
 <20230504121856.904491-3-leitao@debian.org>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <20230504121856.904491-3-leitao@debian.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 5/4/23 13:18, Breno Leitao wrote:
> Currently uring CMD operation relies on having large SQEs, but future
> operations might want to use normal SQE.
> 
> The io_uring_cmd currently only saves the payload (cmd) part of the SQE,
> but, for commands that use normal SQE size, it might be necessary to
> access the initial SQE fields outside of the payload/cmd block.  So,
> saves the whole SQE other than just the pdu.
> 
> This changes slightly how the io_uring_cmd works, since the cmd
> structures and callbacks are not opaque to io_uring anymore. I.e, the
> callbacks can look at the SQE entries, not only, in the cmd structure.
> 
> The main advantage is that we don't need to create custom structures for
> simple commands.
> 
> Creates io_uring_sqe_cmd() that returns the cmd private data as a null
> pointer and avoids casting in the callee side.
> Also, make most of ublk_drv's sqe->cmd priv structure into const, and use
> io_uring_sqe_cmd() to get the private structure, removing the unwanted
> cast. (There is one case where the cast is still needed since the
> header->{len,addr} is updated in the private structure)
> 
> Suggested-by: Pavel Begunkov <asml.silence@gmail.com>
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Keith Busch <kbusch@kernel.org>
> ---
>   drivers/block/ublk_drv.c  | 26 +++++++++++++-------------
>   drivers/nvme/host/ioctl.c |  2 +-
>   include/linux/io_uring.h  |  7 ++++++-
>   io_uring/opdef.c          |  2 +-
>   io_uring/uring_cmd.c      |  9 +++------
>   5 files changed, 24 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
> index c73cc57ec547..42f4d7ca962e 100644
> --- a/drivers/block/ublk_drv.c
> +++ b/drivers/block/ublk_drv.c
[...]
> @@ -2025,7 +2025,7 @@ static int ublk_ctrl_start_recovery(struct ublk_device *ub,
>   static int ublk_ctrl_end_recovery(struct ublk_device *ub,
>   		struct io_uring_cmd *cmd)
>   {
> -	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
> +	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
>   	int ublksrv_pid = (int)header->data[0];
>   	int ret = -EINVAL;
>   
> @@ -2092,7 +2092,7 @@ static int ublk_char_dev_permission(struct ublk_device *ub,
>   static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
>   		struct io_uring_cmd *cmd)
>   {
> -	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
> +	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)io_uring_sqe_cmd(cmd->sqe);

Seems it's here to cast out const. Not an issue as apparently ctrl
goes to io-wq and so copies sqes, and it's definitely not a problem
of this patch, but seems fragile.


>   	bool unprivileged = ub->dev_info.flags & UBLK_F_UNPRIVILEGED_DEV;
>   	void __user *argp = (void __user *)(unsigned long)header->addr;
>   	char *dev_path = NULL;
> @@ -2171,7 +2171,7 @@ static int ublk_ctrl_uring_cmd_permission(struct ublk_device *ub,
>   static int ublk_ctrl_uring_cmd(struct io_uring_cmd *cmd,
>   		unsigned int issue_flags)
>   {
> -	struct ublksrv_ctrl_cmd *header = (struct ublksrv_ctrl_cmd *)cmd->cmd;
> +	const struct ublksrv_ctrl_cmd *header = io_uring_sqe_cmd(cmd->sqe);
>   	struct ublk_device *ub = NULL;
>   	int ret = -EINVAL;
>   
[...]

-- 
Pavel Begunkov
