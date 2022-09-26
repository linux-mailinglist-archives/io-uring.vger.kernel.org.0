Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A43055EA98D
	for <lists+io-uring@lfdr.de>; Mon, 26 Sep 2022 17:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235637AbiIZPFi (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 26 Sep 2022 11:05:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235237AbiIZPEt (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 26 Sep 2022 11:04:49 -0400
Received: from mail-wr1-x42a.google.com (mail-wr1-x42a.google.com [IPv6:2a00:1450:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08174AEDBE
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 06:37:18 -0700 (PDT)
Received: by mail-wr1-x42a.google.com with SMTP id n12so10250580wrx.9
        for <io-uring@vger.kernel.org>; Mon, 26 Sep 2022 06:37:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=hyxm0loyi6UvDO+dEMmD/Ib8wG0nwzxHI86tWmR8X9Q=;
        b=LpMtqW4nGOy1zBMl9rerZ1iweTPQNh5YfFnoi6rwNr4pp3Y0CYzjxu/z1plH1Rtv0Y
         6/29CLyoaHdO5ZjR+amj7pB72kLuLH3ixEmb+jw0phKdmIz17KEoTd8adZfZBXzQiBwA
         jpNwIa2fSFbt6yH70sHUesMYltF8qQCUxjKCtT6PC9Ke7o8neFTmAiXq61h6eAkimc2D
         WXaIX/AmFpg4zZCqJwH2Ejoy0fBENGtXKWITBp70AQjxAoviNJYkOcygvMd2BByS8qqx
         cBTsaC2TgqQcv4ER7KoqdXYvg5/gzwQPpYGk3nqR4oxheFYiMExUDlzbxTsC5aEa1Skt
         zrSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=hyxm0loyi6UvDO+dEMmD/Ib8wG0nwzxHI86tWmR8X9Q=;
        b=g1xwInjE0vnfdssl9PgkSMB9YPbyUVHCDK+l99OKDH6PAkI5lVFrCShT1n0Y2lm7Cm
         2Gu+Xtbzb5NEHfugocmPfrlt1Hm/y7E/waA3B9eWdPfSIHMc+0tluUE/gq+hjnGGfl5y
         xc784TGHCNGn8nEpKZT+kIrfzDcSviEHABKa2UcrhsvAJ4ud88x4UqoSfVbJbgj92I3M
         DHSEC12PPT9bG+gePhuZhereYsKGNKT0P3W5NSgQ6eUhUy3D7mev0skzZMODAgX/5w83
         3dHDF095O+uj2JhvY45m9VYzd32TTgXMvHft40lS21iI8SfdHVFPIXQDb8rNW9+m18pR
         T7DA==
X-Gm-Message-State: ACrzQf3O42xN9PWgh1aLEurqpKBzN7XMO/aqsDKL4wBrf5ler8zTAE2g
        fIMXKDwC+fBs0eyFtlfKO/hXc23Blpk=
X-Google-Smtp-Source: AMsMyM7JeMJI5RHTxifvIBU5KNsP6szQ1YI2LC7mBfek/GloZv7OebzIrUf6vO5QU+lj3Z9lZbUmSA==
X-Received: by 2002:a5d:424c:0:b0:22a:f651:545e with SMTP id s12-20020a5d424c000000b0022af651545emr13069181wrr.639.1664199436152;
        Mon, 26 Sep 2022 06:37:16 -0700 (PDT)
Received: from [192.168.8.100] (188.28.209.34.threembb.co.uk. [188.28.209.34])
        by smtp.gmail.com with ESMTPSA id c8-20020a5d4148000000b0022af865810esm14669483wrq.75.2022.09.26.06.37.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Sep 2022 06:37:15 -0700 (PDT)
Message-ID: <a99be2d9-f133-c0f0-e0b3-839d8381eff2@gmail.com>
Date:   Mon, 26 Sep 2022 14:36:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH for-next] tests: test async_data double-free with sendzc
Content-Language: en-US
To:     io-uring@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>
References: <aae98072a1e606a7f11dd68cf904d1ccb9e39ebe.1664193624.git.asml.silence@gmail.com>
From:   Pavel Begunkov <asml.silence@gmail.com>
In-Reply-To: <aae98072a1e606a7f11dd68cf904d1ccb9e39ebe.1664193624.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

s/for-next/liburing/ in the subject

On 9/26/22 14:33, Pavel Begunkov wrote:
> Similar to send_recv.c:test_invalid().
> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>   test/send-zerocopy.c | 59 ++++++++++++++++++++++++++++++++++++++++++--
>   1 file changed, 57 insertions(+), 2 deletions(-)
> 
> diff --git a/test/send-zerocopy.c b/test/send-zerocopy.c
> index 80723de..1c4e5f2 100644
> --- a/test/send-zerocopy.c
> +++ b/test/send-zerocopy.c
> @@ -533,6 +533,55 @@ static bool io_check_zc_sendmsg(struct io_uring *ring)
>   	return p->ops_len > IORING_OP_SENDMSG_ZC;
>   }
>   
> +/* see also send_recv.c:test_invalid */
> +static int test_invalid_zc(void)
> +{
> +	struct io_uring ring;
> +	int ret, fds[2];
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe;
> +	bool notif = false;
> +
> +	if (!has_sendmsg)
> +		return 0;
> +
> +	ret = t_create_ring(8, &ring, 0);
> +	if (ret)
> +		return ret;
> +	ret = t_create_socket_pair(fds, true);
> +	if (ret)
> +		return ret;
> +
> +	sqe = io_uring_get_sqe(&ring);
> +	io_uring_prep_sendmsg(sqe, fds[0], NULL, MSG_WAITALL);
> +	sqe->opcode = IORING_OP_SENDMSG_ZC;
> +	sqe->flags |= IOSQE_ASYNC;
> +
> +	ret = io_uring_submit(&ring);
> +	if (ret != 1) {
> +		fprintf(stderr, "submit failed %i\n", ret);
> +		return ret;
> +	}
> +	ret = io_uring_wait_cqe(&ring, &cqe);
> +	if (ret)
> +		return 1;
> +	if (cqe->flags & IORING_CQE_F_MORE)
> +		notif = true;
> +	io_uring_cqe_seen(&ring, cqe);
> +
> +	if (notif) {
> +		ret = io_uring_wait_cqe(&ring, &cqe);
> +		if (ret)
> +			return 1;
> +		io_uring_cqe_seen(&ring, cqe);
> +	}
> +
> +	io_uring_queue_exit(&ring);
> +	close(fds[0]);
> +	close(fds[1]);
> +	return 0;
> +}
> +
>   int main(int argc, char *argv[])
>   {
>   	struct io_uring ring;
> @@ -602,7 +651,7 @@ int main(int argc, char *argv[])
>   	ret = test_async_addr(&ring);
>   	if (ret) {
>   		fprintf(stderr, "test_async_addr() failed\n");
> -		return ret;
> +		return T_EXIT_FAIL;
>   	}
>   
>   	ret = t_register_buffers(&ring, buffers_iov, ARRAY_SIZE(buffers_iov));
> @@ -617,7 +666,13 @@ int main(int argc, char *argv[])
>   	ret = test_inet_send(&ring);
>   	if (ret) {
>   		fprintf(stderr, "test_inet_send() failed\n");
> -		return ret;
> +		return T_EXIT_FAIL;
> +	}
> +
> +	ret = test_invalid_zc();
> +	if (ret) {
> +		fprintf(stderr, "test_invalid_zc() failed\n");
> +		return T_EXIT_FAIL;
>   	}
>   out:
>   	io_uring_queue_exit(&ring);

-- 
Pavel Begunkov
