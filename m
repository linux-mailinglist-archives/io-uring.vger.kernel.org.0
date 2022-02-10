Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 342054B02B4
	for <lists+io-uring@lfdr.de>; Thu, 10 Feb 2022 03:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233771AbiBJB57 (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Wed, 9 Feb 2022 20:57:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:33254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233778AbiBJB4N (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Wed, 9 Feb 2022 20:56:13 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53A1C2BB0B
        for <io-uring@vger.kernel.org>; Wed,  9 Feb 2022 17:49:22 -0800 (PST)
Received: from [192.168.88.87] (unknown [36.68.63.145])
        by gnuweeb.org (Postfix) with ESMTPSA id 9D8FD7E293;
        Thu, 10 Feb 2022 00:53:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1644454396;
        bh=RhaqlBcGEM3GHKEe42966QCKUQeu1VAnmA/cCE9/Wjw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=h17H12BkxytErkLh/h9VCtE994BAgn3Ydqavaw1JPKzdHFFQ81VMQqgU0ZiPPU5F6
         aVfNi+mB+eG2cqY/PQPosKYJqRsyHUNP0D/coX50txElcM9AeE/gY7BL1HnFBMAvKB
         nSCgO08KC1LWeiwyZi4AFX5xhBagP/EhEL+DboCb5LQDZxP+iHwzoCFqG7Qer7NKGh
         DthgQBC2t/dmC9Cr87HhfMDz2HpXIPTFisX4kwCENQAzJ8VOI+bsooUF+8P5VVpAH8
         ndrpq2VIwuxHpsMZ93ya95PIwHzU/E4gIZJBJxHFI19e3fTZtOr7ou07jNEKPhBH8K
         5xEHndabb4/oQ==
Message-ID: <01a82b31-cd8c-b40d-ab30-c3a67e29ea41@gnuweeb.org>
Date:   Thu, 10 Feb 2022 07:53:01 +0700
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
> @@ -156,6 +211,16 @@ int main(int argc, char *argv[])
>   		goto err;
>   	}
>   
> +	ret = test_statx_stable(&ring, fname);
> +	if (ret) {
> +		if (ret == -EINVAL) {
> +			fprintf(stdout, "statx not supported, skipping\n");
> +			goto done;
> +		}
> +		fprintf(stderr, "test_statx_loop failed: %d\n", ret);
> +		goto err;
> +	}
> +

Why do we call it test_statx_loop? Isn't the function name test_statx_stable?

-- 
Ammar Faizi
