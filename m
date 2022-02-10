Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F9774B02AD
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 03:01:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233984AbiBJB7S (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Feb 2022 20:59:18 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:60146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234228AbiBJB7G (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Feb 2022 20:59:06 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A32DB2BB34
        for <io-uring@vger.kernel.org>; Wed,  9 Feb 2022 17:54:19 -0800 (PST)
Received: from [192.168.88.87] (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id D98717E25B;
        Thu, 10 Feb 2022 00:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644453813;
        bh=xNROmmrlh40NY9l6J6uJAsc8XhO6vG9u9xaauU8IgT0=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=FZXr1W6eijRp+tadTrcjFDSL4hgDNFyrUhV/kvYto4fzLI0EPlfWdbtxBPLMpO3S7
         o2jdJV6fbuUZiwvtlgJ+5yq/IQ7DT7KPMnR2J5CNuNpoDlWvKiSC1uGX458P1SXCrX
         FoxL6xu9jZirzePzQdyaL4RFudXgv4+Xq3ZlTsRq5RUUj5IKlKb4xNN7NdxxdsOYYt
         rHlxJ/s16tcGcG1qF9SaahG32gsxKPtNpqnywe1fxNFQNcM8nlIMoidXA4AV+66oRq
         ROCXoDLYcATH1nQCqBrf43ZlUcsKvJVp7yUMZ5KeOQ0zADl84sbHfc+m0rrJggGTx4
         3roAsGUfxPClQ==
Message-ID: <c8ba26bf-1eb9-69e9-8598-920a07777dc4@gnuweeb.org>
Date:   Thu, 10 Feb 2022 07:43:16 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v1] liburing: add test for stable statx api
Content-Language: en-US
To:     Stefan Roesch <shr@fb.com>, io-uring@vger.kernel.org,
        kernel-team@fb.com
Cc:     viro@zeniv.linux.org.uk
References: <20220209190430.2378305-1-shr@fb.com>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
In-Reply-To: <20220209190430.2378305-1-shr@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 2/10/22 2:04 AM, Stefan Roesch wrote:
> This adds a test for the statx api to verify that io-uring statx api is
> stable.
> 
> Signed-off-by: Stefan Roesch <shr@fb.com>
> ---
>   test/statx.c | 65 ++++++++++++++++++++++++++++++++++++++++++++++++++++
>   1 file changed, 65 insertions(+)
> 
> diff --git a/test/statx.c b/test/statx.c
> index c0f9e9c..61268d4 100644
> --- a/test/statx.c
> +++ b/test/statx.c
> @@ -77,6 +77,61 @@ err:
>   	return -1;
>   }
>   
> +static int test_statx_stable(struct io_uring *ring, const char *path)
> +{
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe;
> +	struct statx x1, x2;
> +	char path1[PATH_MAX];
> +	char path2[PATH_MAX];
> +	int ret = -1;
> +
> +	strcpy(path2, path);
> +	strcpy(path1, path);
> +
> +	sqe = io_uring_get_sqe(ring);
> +	if (!sqe) {
> +		fprintf(stderr, "get sqe failed\n");
> +		goto err;
> +	}
> +
> +	io_uring_prep_statx(sqe, -1, path1, 0, STATX_ALL, &x1);
> +
> +	ret = io_uring_submit(ring);
> +	if (ret <= 0) {
> +		fprintf(stderr, "sqe submit failed: %d\n", ret);
> +		goto err;
> +	}
> +	memset(path1, 0, sizeof(path1));
> +
> +	ret = io_uring_wait_cqe(ring, &cqe);
> +	if (ret < 0) {
> +		fprintf(stderr, "wait completion %d\n", ret);
> +		goto err;
> +	}
> +
> +	ret = cqe->res;
> +	io_uring_cqe_seen(ring, cqe);
> +	if (ret) {
> +		fprintf(stderr, "statx res = %d\n", ret);
> +		goto err;
> +	}
> +
> +	ret = do_statx(-1, path2, 0, STATX_ALL, &x2);
> +	if (ret < 0)
> +		return statx_syscall_supported();
> +
> +	if (memcmp(&x1, &x2, sizeof(x1))) {
> +		fprintf(stderr, "Miscompare between io_uring and statx\n");
> +		goto err;
> +	}

If we fail on memcmp() here, the ret should be set to non-zero *explicitly*.
Otherwise, we have zero exit code since statx returns 0 on success.

I think that one can also be simplified like this:

	ret = memcmp(&x1, &x2, sizeof(x1));
	if (ret)
		fprintf(stderr, "Miscompare between io_uring and statx\n");
	return ret;


-- 
Ammar Faizi
