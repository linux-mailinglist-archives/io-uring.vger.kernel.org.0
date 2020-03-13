Return-Path: <io-uring-owner@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D183918512A
	for <lists+io-uring@lfdr.de>; Fri, 13 Mar 2020 22:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726620AbgCMVaX (ORCPT <rfc822;lists+io-uring@lfdr.de>);
        Fri, 13 Mar 2020 17:30:23 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:37926 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgCMVaX (ORCPT
        <rfc822;io-uring@vger.kernel.org>); Fri, 13 Mar 2020 17:30:23 -0400
Received: by mail-wm1-f66.google.com with SMTP id t13so5422312wmi.3;
        Fri, 13 Mar 2020 14:30:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:references:autocrypt:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language;
        bh=CqyfsQ+GcAHAK8PNaEMxTzEpim0orONrrYP7CqdUzRA=;
        b=lnhU3AsGmmbJSmqqtk+KiUssV5RSpyvM/O4vsLmgAm8Rxu6IcutNHlnnPPOqbx/2Gy
         InqMlYU0iKuhqRz+JqqaeAxEmIAo6HMbNILvgR+/2y0e3fwwj333/YbUTetjFt9GiATT
         6ttGU7wnrznZDVpc3LAlXn4dRZNRhKzfeDGfOT6XRa0Yr8w+Eyx+P7epdkIUep02y5IG
         haIvVg3rOZ1z4kZ2fH9IHi6SzD2UvJ7WW4nQRBSkO5yyllY/9aozwArrzdFVLwIPLIw6
         QrlhVEsyPZWL/dWiG7EIgLLD5MN2h6jHnP8bWOEKE5mFyD2MldhO9NIlMpWk55pzdlaQ
         D/Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:references:autocrypt:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language;
        bh=CqyfsQ+GcAHAK8PNaEMxTzEpim0orONrrYP7CqdUzRA=;
        b=kD0BVvVUI7tT7FyT+L3sJyYlcSpnWR97sq+6U0Q8qsL1bAfu3ysVFNbWyZ2RC8IPzA
         FBiPakgvxvUTYJsb/iLF5iwgl9OrmH6uCQcQHW3at3ra9zZR6F/zNOfYTekwGrcOnkdA
         pykmA3eG00tFAdxD6gd8DViR2vEMowITBk1MH3oQth46CN48Txzic+WtBSpkx8I5e7Zr
         nXEzLrEu0VAmotXk5tSvuJ2IMJfMO7bRsqW4K5c5nRJ+Gu30kJcLnASX4jQdmWvpIlIh
         QwHpxNs2smAkE06IPVWhb+aTg6ur32ttU6grZ8xPUHACV8Z54vZZ3U3DN1zH2xkYzlmV
         q/IQ==
X-Gm-Message-State: ANhLgQ3kyPOS5d6lebq48U/9la5l1HRl01rRf/jm84OwtbjNBKDupUPJ
        1ZTtyzWanLVRkJEFb956hpoCEIek
X-Google-Smtp-Source: ADFU+vuRCVhwCX3a3nW+pBFJ8DPbnOEAmpJNInYh/ueA7jYGaEV4jND5x0TWf+0j7q0OlkWTH493BA==
X-Received: by 2002:a05:600c:2297:: with SMTP id 23mr1661019wmf.135.1584135019875;
        Fri, 13 Mar 2020 14:30:19 -0700 (PDT)
Received: from [192.168.43.85] ([109.126.140.227])
        by smtp.gmail.com with ESMTPSA id j39sm2533532wre.11.2020.03.13.14.30.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Mar 2020 14:30:19 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <3fff749b19ae1c3c2d59e88462a8a5bfc9e6689f.1584127615.git.asml.silence@gmail.com>
 <bc3baf1c-0629-3989-c7c1-bc7c84ac8ae5@gmail.com>
Autocrypt: addr=asml.silence@gmail.com; prefer-encrypt=mutual; keydata=
 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 bA==
Subject: Re: [PATCH 5.6] io_uring: NULL-deref for IOSQE_{ASYNC,DRAIN}
Message-ID: <6ebc5e8a-7a6c-2537-9050-fe4e5c4f014d@gmail.com>
Date:   Sat, 14 Mar 2020 00:29:28 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.3.0
MIME-Version: 1.0
In-Reply-To: <bc3baf1c-0629-3989-c7c1-bc7c84ac8ae5@gmail.com>
Content-Type: multipart/mixed;
 boundary="------------469F7EDE0EF494D8D39C6C7F"
Content-Language: en-US
Sender: io-uring-owner@vger.kernel.org
Precedence: bulk
List-ID: <io-uring.vger.kernel.org>
X-Mailing-List: io-uring@vger.kernel.org

This is a multi-part message in MIME format.
--------------469F7EDE0EF494D8D39C6C7F
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

On 13/03/2020 23:28, Pavel Begunkov wrote:
> Hmm, found unreliably failing the across-fork test. I don't know whether it's
> this patch specific, but need to take a look there first.

It's good to go, just used outdated tests.
The reproducer is attached.

> 
>>
>> Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
>> ---
>>  fs/io_uring.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/fs/io_uring.c b/fs/io_uring.c
>> index 55afae6f0cf4..9d43efbec960 100644
>> --- a/fs/io_uring.c
>> +++ b/fs/io_uring.c
>> @@ -4813,6 +4813,9 @@ static int io_req_defer_prep(struct io_kiocb *req,
>>  {
>>  	ssize_t ret = 0;
>>  
>> +	if (!sqe)
>> +		return 0;
>> +
>>  	if (io_op_defs[req->opcode].file_table) {
>>  		ret = io_grab_files(req);
>>  		if (unlikely(ret))
>> @@ -5655,6 +5658,11 @@ static bool io_submit_sqe(struct io_kiocb *req, const struct io_uring_sqe *sqe,
>>  		if (sqe_flags & (IOSQE_IO_LINK|IOSQE_IO_HARDLINK)) {
>>  			req->flags |= REQ_F_LINK;
>>  			INIT_LIST_HEAD(&req->link_list);
>> +
>> +			if (io_alloc_async_ctx(req)) {
>> +				ret = -EAGAIN;
>> +				goto err_req;
>> +			}
>>  			ret = io_req_defer_prep(req, sqe);
>>  			if (ret)
>>  				req->flags |= REQ_F_FAIL_LINK;
>>
> 

-- 
Pavel Begunkov

--------------469F7EDE0EF494D8D39C6C7F
Content-Type: text/x-csrc; charset=UTF-8;
 name="read-write2.c"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="read-write2.c"

#include <errno.h>
#include <stdio.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include <fcntl.h>
#include <sys/types.h>
#include <sys/poll.h>
#include <sys/eventfd.h>
#include "liburing.h"

#define BS		4096
static struct iovec vecs[1];
static int no_read;

static int create_file(const char *file)
{
	ssize_t ret;
	char *buf;
	int fd;

	buf =3D malloc(BS);
	memset(buf, 0xaa, BS);

	fd =3D open(file, O_WRONLY | O_CREAT, 0644);
	if (fd < 0) {
		perror("open file");
		return 1;
	}
	ret =3D write(fd, buf, BS);
	close(fd);
	return ret !=3D BS;
}


static int create_buffers(void)
{
	if (posix_memalign(&vecs[0].iov_base, BS, BS))
		return 1;
	vecs[0].iov_len =3D BS;
	return 0;
}

static int test_io(const char *file)
{
	const int nr_links =3D 100;
	const int link_len =3D 100;
	const int nr_sqes =3D nr_links * link_len;
	struct io_uring_sqe *sqe;
	struct io_uring_cqe *cqe;
	struct io_uring ring;
	int i, fd, ret;
	static int warned;

	fd =3D open(file, O_WRONLY);
	if (fd < 0) {
		perror("file open");
		goto err;
	}

	ret =3D io_uring_queue_init(nr_sqes, &ring, 0);
	if (ret) {
		fprintf(stderr, "ring create failed: %d\n", ret);
		goto err;
	}

	for (int i =3D 0; i < nr_links; ++i) {
		for (int j =3D 0; j < link_len; ++j) {
			sqe =3D io_uring_get_sqe(&ring);
			if (!sqe) {
				fprintf(stderr, "sqe get failed\n");
				goto err;
			}
			io_uring_prep_writev(sqe, fd, &vecs[0], 1, 0);
			sqe->flags |=3D IOSQE_ASYNC;
			if (j !=3D link_len - 1)
				sqe->flags |=3D IOSQE_IO_LINK;
		}
	}

	ret =3D io_uring_submit(&ring);
	if (ret !=3D nr_sqes) {
		fprintf(stderr, "submit got %d, wanted %d\n", ret, nr_sqes);
		goto err;
	}

	for (i =3D 0; i < nr_sqes; i++) {
		ret =3D io_uring_wait_cqe(&ring, &cqe);
		if (ret) {
			fprintf(stderr, "wait_cqe=3D%d\n", ret);
			goto err;
		}
		if (cqe->res =3D=3D -EINVAL) {
			if (!warned) {
				fprintf(stdout, "Non-vectored IO not "
					"supported, skipping\n");
				warned =3D 1;
				no_read =3D 1;
			}
		} else if (cqe->res !=3D BS) {
			fprintf(stderr, "cqe res %d, wanted %d\n", cqe->res, BS);
			goto err;
		}
		io_uring_cqe_seen(&ring, cqe);
	}

	io_uring_queue_exit(&ring);
	close(fd);
	return 0;
err:
	if (fd !=3D -1)
		close(fd);
	return 1;
}

int main(int argc, char *argv[])
{
	if (create_file(".basic-rw")) {
		fprintf(stderr, "file creation failed\n");
		goto err;
	}
	if (create_buffers()) {
		fprintf(stderr, "file creation failed\n");
		goto err;
	}


	test_io(".basic-rw");
	unlink(".basic-rw");
	return 0;
err:
	unlink(".basic-rw");
	return 1;
}

--------------469F7EDE0EF494D8D39C6C7F--
