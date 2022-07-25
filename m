Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CAF157FDA3
	for <lists+io-uring@lfdr.de>; Mon, 25 Jul 2022 12:36:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233700AbiGYKgJ (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Mon, 25 Jul 2022 06:36:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56436 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234582AbiGYKgH (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Mon, 25 Jul 2022 06:36:07 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F26C1836D
        for <io-uring@vger.kernel.org>; Mon, 25 Jul 2022 03:36:04 -0700 (PDT)
Received: from [192.168.88.254] (unknown [125.160.106.238])
        by gnuweeb.org (Postfix) with ESMTPSA id 2767A7E328;
        Mon, 25 Jul 2022 10:36:01 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1658745363;
        bh=zTZAY+Bj3b1F2SJxJhqP73daXW50NEr6CKo1+T4084U=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=UkUWeIZUWiHJowIUWiGfHYNkBQsIKTFW+SCWkrQDRPHoggt9EFHGBmSXxaAsGSV14
         CnMxuDbf6cugMYrlWFvMInfiKFFzJYKdcSgCTdJXXUJDjG4wRRZTVCqDZYRGv8K/gS
         RUGlZ5DvfIQKTLIXuoO/Sti5zcdmqVbAiEfyxUotWrXQbECQ9hSuv5vveAiPfofBh8
         DtWbiiUe7WsPuHVp78SQqcJY3n2OxPFJI8lF1cWlVGQse7/OZFRDbXeYCSONiLpGsU
         gyLa1bRaG2Y/EfwB6yVn8wpBPyYRw8BiHLAC4GSlh6BRwwhQQSajHWIvcif5qw+/nR
         w0x8aJlTPEdgA==
Message-ID: <bf034949-b5b3-f155-ca33-781712273881@gnuweeb.org>
Date:   Mon, 25 Jul 2022 17:35:59 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH liburing 3/4] tests: add tests for zerocopy send and
 notifications
Content-Language: en-US
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     Jens Axboe <axboe@kernel.dk>,
        io-uring Mailing List <io-uring@vger.kernel.org>
References: <cover.1658743360.git.asml.silence@gmail.com>
 <92dccd4b172d5511646d72c51205241aa2e62458.1658743360.git.asml.silence@gmail.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <92dccd4b172d5511646d72c51205241aa2e62458.1658743360.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 7/25/22 5:03 PM, Pavel Begunkov wrote:> diff --git a/test/Makefile b/test/Makefile
> index 8945368..7b6018c 100644
> --- a/test/Makefile
> +++ b/test/Makefile
> @@ -175,6 +175,7 @@ test_srcs := \
>   	xattr.c \
>   	skip-cqe.c \
>   	single-issuer.c \
> +	send-zcopy.c \
>   	# EOL

I have been trying to keep this list sorted alphabetically. Can we?

> +int main(int argc, char *argv[])
> +{
> +	struct io_uring ring;
> +	int i, ret, sp[2];
> +
> +	if (argc > 1)
> +		return 0;

New test should use the provided exit code protocol. This should have
been "return T_EXIT_SKIP;"

> +	ret = io_uring_queue_init(32, &ring, 0);
> +	if (ret) {
> +		fprintf(stderr, "queue init failed: %d\n", ret);
> +		return 1;
> +	}

This should have been "return T_EXIT_FAIL;".

> +	ret = register_notifications(&ring);
> +	if (ret == -EINVAL) {
> +		printf("sendzc is not supported, skip\n");
> +		return 0;
> +	} else if (ret) {
> +		fprintf(stderr, "register notif failed %i\n", ret);
> +		return 1;
> +	}
[...]
> +
> +out:
> +	io_uring_queue_exit(&ring);
> +	close(sp[0]);
> +	close(sp[1]);
> +	return 0;
> +}

and so on...

-- 
Ammar Faizi
