Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F08286BFAE1
	for <lists+io-uring@lfdr.de>; Sat, 18 Mar 2023 15:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229628AbjCRObx (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sat, 18 Mar 2023 10:31:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229648AbjCRObw (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sat, 18 Mar 2023 10:31:52 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9926838457
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 07:31:46 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id cn6so8055468pjb.2
        for <io-uring@vger.kernel.org>; Sat, 18 Mar 2023 07:31:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1679149906; x=1681741906;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2CcTCSKyoFSR4JaDnvBESywdYcTmjXT52y248CjSjOE=;
        b=e+6lmIPaiRX0CqIUttFJBrndWQYiZ0ZxwNhH4+ucCoV89Z3i1NjHIfUb0bYL95xv+w
         GhK8KVI/xxrqtPDMv0TvYy3jMsJfBZjchEtJCrAtthjeqvej6tDcmFVTDXk9n7/Dyf3C
         yvNVYaxV/bpiDKmDbdro76BjAuB34d8nN/ePhj32dKBU3JwtdxDzoxN8fSuyKHijQXyP
         zcUVET2SuKvBdn1MKwc3bMwGX20LUJIZU4YKa1HOiAQ/ehshWaCGgr3/s91bJBvLEVhN
         eNi5o7QWOWvC2l8m4HohiZkY1qkfwTSTchjyvR3TMLrCjplQCtD+9ZyR8BzzEWJCXidr
         Vdrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679149906; x=1681741906;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2CcTCSKyoFSR4JaDnvBESywdYcTmjXT52y248CjSjOE=;
        b=kvgsJoWw+id3P0sgLn26oYTR2wPbxQgmKV11O7OzCdgQqHefH3EmmMnj/MgJqJS2VC
         y7Mn6ocm8Vfzli0TTjnwLNu4J4gvjQk+qcOnc0TdMOQ630p9xXEEgUnApVcF9e42Wa1t
         3CGcQd3/hkisfZOz46ALRUvJIsUJLpfBrnUowYRa+5M+8BSdbRwxmREyVqv39JQ6Np3S
         hRqgUCbnOyD3bZTftLaw/394v4sjaHdUsK1emC0K4rARCcMsbEra3DgJGHOeOPnyL0y9
         EKjYtwBnl8WXRBq/GYjr7YW0scoBZiotEilszYnXb1YCTg2El/nVO5nCB4DPpqx/UH5Z
         gp6w==
X-Gm-Message-State: AO0yUKVKftCe1+wCRYlrNSepGKRiJK6lfUgHbAwU+4vN5/taZFRLWiTK
        o7nEBcvD/+Ua2JM+q5Nk6oiRq37lQiI72Iy966IoYQ==
X-Google-Smtp-Source: AK7set8ytrG+LBNVevvm4pzwJdQiHhcnJ+fWa3hzo1NRtfYikvYqTjsTD7cMsWTGyBv56961LKmzDg==
X-Received: by 2002:a17:902:ef8d:b0:19d:1e21:7f59 with SMTP id iz13-20020a170902ef8d00b0019d1e217f59mr13557969plb.0.1679149905984;
        Sat, 18 Mar 2023 07:31:45 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id jw20-20020a170903279400b001a0428bd8c4sm3358198plb.289.2023.03.18.07.31.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 18 Mar 2023 07:31:45 -0700 (PDT)
Message-ID: <e92b121c-553a-b699-11ca-746ff2522d7e@kernel.dk>
Date:   Sat, 18 Mar 2023 08:31:44 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH V3 02/16] io_uring: add IORING_OP_FUSED_CMD
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>, io-uring@vger.kernel.org,
        linux-block@vger.kernel.org
Cc:     Miklos Szeredi <mszeredi@redhat.com>,
        ZiyangZhang <ZiyangZhang@linux.alibaba.com>,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        Bernd Schubert <bschubert@ddn.com>,
        Pavel Begunkov <asml.silence@gmail.com>
References: <20230314125727.1731233-1-ming.lei@redhat.com>
 <20230314125727.1731233-3-ming.lei@redhat.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230314125727.1731233-3-ming.lei@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_SBL_CSS,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 3/14/23 6:57?AM, Ming Lei wrote:
> Add IORING_OP_FUSED_CMD, it is one special URING_CMD, which has to
> be SQE128. The 1st SQE(master) is one 64byte URING_CMD, and the 2nd
> 64byte SQE(slave) is another normal 64byte OP. For any OP which needs
> to support slave OP, io_issue_defs[op].fused_slave has to be set as 1,
> and its ->issue() needs to retrieve buffer from master request's
> fused_cmd_kbuf.

Since we'd be introducing this as a new concept, probably makes sense to
name it something other than master/slave. What about primary and
secondary? Producer/consumer?

> +static inline bool io_fused_slave_write_to_buf(u8 op)
> +{
> +	switch (op) {
> +	case IORING_OP_READ:
> +	case IORING_OP_READV:
> +	case IORING_OP_READ_FIXED:
> +	case IORING_OP_RECVMSG:
> +	case IORING_OP_RECV:
> +		return 1;
> +	default:
> +		return 0;
> +	}
> +}

Maybe add a data direction bit to the hot opdef part? Any command that
has fused support should ensure that it is set correctly.

> +int io_import_kbuf_for_slave(unsigned long buf_off, unsigned int len, int dir,
> +		struct iov_iter *iter, struct io_kiocb *slave)
> +{

The kbuf naming should probably also change, as it kind of overlaps with
the kbufs we already have and which are not really related.

-- 
Jens Axboe

