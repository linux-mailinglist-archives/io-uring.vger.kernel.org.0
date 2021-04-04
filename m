Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C34673537D1
	for <lists+io-uring@lfdr.de>; Sun,  4 Apr 2021 12:50:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230397AbhDDKuM (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Sun, 4 Apr 2021 06:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230180AbhDDKuL (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Sun, 4 Apr 2021 06:50:11 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BB96C061756
        for <io-uring@vger.kernel.org>; Sun,  4 Apr 2021 03:50:06 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id c8so8504704wrq.11
        for <io-uring@vger.kernel.org>; Sun, 04 Apr 2021 03:50:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:references:autocrypt:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=PVj1XTMtncgkj12du7ScTNiwShWPTuR66eAdzXn2EWA=;
        b=eMKhkIZnjfAo+V52YZ43U9EnvJSTyUV0tA6ZnrpFfOiSihbNPWcp4PkW1R+0QC+4eh
         vFO+fw9GTByaK3R7EFUBckoFEJXTYnskCHA+CSlgxIB0wc3MbJ16USJgzS2cy7KLMlK7
         wHKTDkuPckis83IJ2ZJ7wwQDJ5D1avQT949ZxxNYO4Vlrm5vUTZn4YpGRUWqVPsR7AzS
         2cDcsJVwmr67ek5nw0UBtieAfIpiHjvman+uTztHZUFW0SrXUDTRpk5OEJ+xUuAmEGs6
         Q2CHoRBEHK79PPxLjIZAbs+1hOveS1wFOWIsDEsXqTUC/V5+NDu6gTNFolabPwXDWCO6
         sZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:autocrypt:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=PVj1XTMtncgkj12du7ScTNiwShWPTuR66eAdzXn2EWA=;
        b=LUnKWUIaVaCUwLekfso29Rn5mQPhnVseZ9XTfv04sTTjFs2OFaFE/WzfflKhfLATru
         1TKjkIKVQhV0/yaJhzqsXXdNWESDspofuldOJ0LA/kx+/VkzaH7aLxYOz/GVjqDsF9dv
         pygla4uCTmkJ3/vAObxSjYTyjlV78H0VbGr8JLDtTQjWKEqMnJrsaXBVTrA+jCeMheh+
         wnhiy6lAxLXgfaJqy7UNGyU95zLNq7NNCa1xpM2yNkgi/qA0t8F8wv19NdP+3PGBDeXF
         Hqtmye0mc68VB7v5ebX5cVYmnBb9dEvOeYslWoWL0dpBG1Y8mrsn/AJic+lpBNv0mB5x
         NFFQ==
X-Gm-Message-State: AOAM533+J3U/gYEggyvuL/Gs+MBK4WdHUmd37/q6K0JwLksplSjsg8zq
        FAfo9nLX0jkwM7jG+a8pA4EF+COWSHe/oA==
X-Google-Smtp-Source: ABdhPJxCUq79zK8Do+mXmWnJplTnSnA1hFH0M4gM26oLG8ZNZvkHfSf0N9JVjWEt+BZBpdmjeHOrNA==
X-Received: by 2002:a5d:6c6a:: with SMTP id r10mr24170889wrz.42.1617533404668;
        Sun, 04 Apr 2021 03:50:04 -0700 (PDT)
Received: from [192.168.8.132] ([148.252.129.227])
        by smtp.gmail.com with ESMTPSA id o5sm5179541wmc.44.2021.04.04.03.50.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 04 Apr 2021 03:50:04 -0700 (PDT)
Subject: Re: [PATCH liburing] tests: test CQE ordering on early submission
 fail
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <bfc0ffac5d54adeb3472ec6160f6aeaf8f70c1ca.1617099951.git.asml.silence@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Message-ID: <600acb5f-d8a0-4589-29ae-3e8a517fcb7e@gmail.com>
Date:   Sun, 4 Apr 2021 11:45:59 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <bfc0ffac5d54adeb3472ec6160f6aeaf8f70c1ca.1617099951.git.asml.silence@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

On 30/03/2021 11:26, Pavel Begunkov wrote:
> Check that CQEs of a link comes in the order of submission, even when
> a link fails early during submission initial prep.

up

> 
> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
> ---
>  test/link.c | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 53 insertions(+)
> 
> diff --git a/test/link.c b/test/link.c
> index c89d6b2..fadd0b5 100644
> --- a/test/link.c
> +++ b/test/link.c
> @@ -429,6 +429,53 @@ err:
>  	return 1;
>  }
>  
> +static int test_link_fail_ordering(struct io_uring *ring)
> +{
> +	struct io_uring_cqe *cqe;
> +	struct io_uring_sqe *sqe;
> +	int ret, i, nr_compl;
> +
> +	sqe = io_uring_get_sqe(ring);
> +	io_uring_prep_nop(sqe);
> +	sqe->flags |= IOSQE_IO_LINK;
> +	sqe->user_data = 0;
> +
> +	sqe = io_uring_get_sqe(ring);
> +	io_uring_prep_write(sqe, -1, NULL, 100, 0);
> +	sqe->flags |= IOSQE_IO_LINK;
> +	sqe->user_data = 1;
> +
> +	sqe = io_uring_get_sqe(ring);
> +	io_uring_prep_nop(sqe);
> +	sqe->flags |= IOSQE_IO_LINK;
> +	sqe->user_data = 2;
> +
> +	nr_compl = ret = io_uring_submit(ring);
> +	/* at least the first nop should have been submitted */
> +	if (ret < 1) {
> +		fprintf(stderr, "sqe submit failed: %d\n", ret);
> +		goto err;
> +	}
> +
> +	for (i = 0; i < nr_compl; i++) {
> +		ret = io_uring_wait_cqe(ring, &cqe);
> +		if (ret) {
> +			fprintf(stderr, "wait completion %d\n", ret);
> +			goto err;
> +		}
> +		if (cqe->user_data != i) {
> +			fprintf(stderr, "wrong CQE order, got %i, expected %i\n",
> +					(int)cqe->user_data, i);
> +			goto err;
> +		}
> +		io_uring_cqe_seen(ring, cqe);
> +	}
> +
> +	return 0;
> +err:
> +	return 1;
> +}
> +
>  int main(int argc, char *argv[])
>  {
>  	struct io_uring ring, poll_ring;
> @@ -492,5 +539,11 @@ int main(int argc, char *argv[])
>  		return ret;
>  	}
>  
> +	ret = test_link_fail_ordering(&ring);
> +	if (ret) {
> +		fprintf(stderr, "test_link_fail_ordering last failed\n");
> +		return ret;
> +	}
> +
>  	return 0;
>  }
> 

-- 
Pavel Begunkov
