Return-Path: <io-uring+bounces-2061-lists+io-uring=lfdr.de@vger.kernel.org>
X-Original-To: lists+io-uring@lfdr.de
Delivered-To: lists+io-uring@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 7C5608D745D
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 10:58:33 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id D3DC11F21191
	for <lists+io-uring@lfdr.de>; Sun,  2 Jun 2024 08:58:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6995E249E5;
	Sun,  2 Jun 2024 08:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=s.muenzel.net header.i=@s.muenzel.net header.b="v9YDt0ZZ"
X-Original-To: io-uring@vger.kernel.org
Received: from out-187.mta0.migadu.com (out-187.mta0.migadu.com [91.218.175.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA3E213ACC
	for <io-uring@vger.kernel.org>; Sun,  2 Jun 2024 08:58:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717318708; cv=none; b=UDe1wQXc+Ch3runw5RV5qNudvfmzavDxbAQr99keQH7grU46+8oNIBF1FPdwnxAdVlMnSGlzM4gAL7CoYfgvWGt0doHQfqzgy1v0KVSUz0+zl8kPP5HxHtO9gH9O7R+nG8VArE4NCPuFbRfzOeXC9fIW1eAG5IHJAuGqtY+2Zb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717318708; c=relaxed/simple;
	bh=FDPaB79oDHTKw5hios5th0f9m9GllhCjsa9iSk7BvcQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=sFNxu4ajaCP4QnhwdXQW1AB6ahw5WbrW0Jqe6bJ++J0ceL/er/lMQktEkILZ10dWGSXs1tpR+KcJ42J/P6oSApSQVInmWLmq4et1DG2PlbKLLc9qvwNa9MU7SYGmtiPZ0+L44odCDP2nvLnG/bPEpxrxZzhYTCCaVSiSIYmZeqQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=s.muenzel.net; spf=pass smtp.mailfrom=s.muenzel.net; dkim=pass (1024-bit key) header.d=s.muenzel.net header.i=@s.muenzel.net header.b=v9YDt0ZZ; arc=none smtp.client-ip=91.218.175.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=s.muenzel.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=s.muenzel.net
X-Envelope-To: axboe@kernel.dk
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=s.muenzel.net;
	s=default; t=1717318702;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=//EgpEIB8cMmv3eErVhrj8VROZ/ZEm19kKhVM/ArZKU=;
	b=v9YDt0ZZhCPd/Hj3Z1OyQ7pC7HzQzb5RU9UXLApqZc0d4fBFXTD9p19pPRR+qwDGang05h
	sHtP0m0JzQ0orWglYeQHZ5vcD8z8NsvEf6bczpm9qYwY3HmNMUZufKUkJjOo0yIvKaCeJw
	gQXDaxoH+IwjXlpM0MDAYHL0k82Jed4=
X-Envelope-To: io-uring@vger.kernel.org
Message-ID: <b7fd035e-6ec2-4482-93e9-acb7436ca07e@s.muenzel.net>
Date: Sun, 2 Jun 2024 10:58:30 +0200
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Subject: Re: madvise/fadvise 32-bit length
To: Jens Axboe <axboe@kernel.dk>, io-uring@vger.kernel.org
References: <bc92a2fa-4400-4c3a-8766-c2e346113ea7@s.muenzel.net>
 <db4d32d6-cc71-4903-92cf-b1867b8c7d12@kernel.dk>
 <2d4d3434-401c-42c2-b450-40dec4689797@kernel.dk>
 <c9059b69-96d0-45e6-8d05-e44298d7548e@s.muenzel.net>
 <d6e2f493-87ca-4203-8d23-2ced10d47d02@kernel.dk>
 <8b08398d-a66d-42ad-a776-78b52d5231c4@s.muenzel.net>
 <c6c149ac-ce0e-4c21-b235-03b5d8250d86@kernel.dk>
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Stefan <source@s.muenzel.net>
In-Reply-To: <c6c149ac-ce0e-4c21-b235-03b5d8250d86@kernel.dk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

On 1/6/2024 20:33, Jens Axboe wrote:
> On 6/1/24 9:51 AM, Stefan wrote:
>> On 1/6/2024 17:35, Jens Axboe wrote:
>>> On 6/1/24 9:22 AM, Stefan wrote:
>>>> On 1/6/2024 17:05, Jens Axboe wrote:
>>>>> On 6/1/24 8:19 AM, Jens Axboe wrote:
>>>>>> On 6/1/24 3:43 AM, Stefan wrote:
>>>>>>> io_uring uses the __u32 len field in order to pass the length to
>>>>>>> madvise and fadvise, but these calls use an off_t, which is 64bit on
>>>>>>> 64bit platforms.
>>>>>>>
>>>>>>> When using liburing, the length is silently truncated to 32bits (so
>>>>>>> 8GB length would become zero, which has a different meaning of "until
>>>>>>> the end of the file" for fadvise).
>>>>>>>
>>>>>>> If my understanding is correct, we could fix this by introducing new
>>>>>>> operations MADVISE64 and FADVISE64, which use the addr3 field instead
>>>>>>> of the length field for length.
>>>>>>
>>>>>> We probably just want to introduce a flag and ensure that older stable
>>>>>> kernels check it, and then use a 64-bit field for it when the flag is
>>>>>> set.
>>>>>
>>>>> I think this should do it on the kernel side, as we already check these
>>>>> fields and return -EINVAL as needed. Should also be trivial to backport.
>>>>> Totally untested... Might want a FEAT flag for this, or something where
>>>>> it's detectable, to make the liburing change straight forward.
>>>>>
>>>>>
>>>>> diff --git a/io_uring/advise.c b/io_uring/advise.c
>>>>> index 7085804c513c..cb7b881665e5 100644
>>>>> --- a/io_uring/advise.c
>>>>> +++ b/io_uring/advise.c
>>>>> @@ -17,14 +17,14 @@
>>>>>     struct io_fadvise {
>>>>>         struct file            *file;
>>>>>         u64                offset;
>>>>> -    u32                len;
>>>>> +    u64                len;
>>>>>         u32                advice;
>>>>>     };
>>>>>       struct io_madvise {
>>>>>         struct file            *file;
>>>>>         u64                addr;
>>>>> -    u32                len;
>>>>> +    u64                len;
>>>>>         u32                advice;
>>>>>     };
>>>>>     @@ -33,11 +33,13 @@ int io_madvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>     #if defined(CONFIG_ADVISE_SYSCALLS) && defined(CONFIG_MMU)
>>>>>         struct io_madvise *ma = io_kiocb_to_cmd(req, struct io_madvise);
>>>>>     -    if (sqe->buf_index || sqe->off || sqe->splice_fd_in)
>>>>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>>>>             return -EINVAL;
>>>>>           ma->addr = READ_ONCE(sqe->addr);
>>>>> -    ma->len = READ_ONCE(sqe->len);
>>>>> +    ma->len = READ_ONCE(sqe->off);
>>>>> +    if (!ma->len)
>>>>> +        ma->len = READ_ONCE(sqe->len);
>>>>>         ma->advice = READ_ONCE(sqe->fadvise_advice);
>>>>>         req->flags |= REQ_F_FORCE_ASYNC;
>>>>>         return 0;
>>>>> @@ -78,11 +80,13 @@ int io_fadvise_prep(struct io_kiocb *req, const struct io_uring_sqe *sqe)
>>>>>     {
>>>>>         struct io_fadvise *fa = io_kiocb_to_cmd(req, struct io_fadvise);
>>>>>     -    if (sqe->buf_index || sqe->addr || sqe->splice_fd_in)
>>>>> +    if (sqe->buf_index || sqe->splice_fd_in)
>>>>>             return -EINVAL;
>>>>>           fa->offset = READ_ONCE(sqe->off);
>>>>> -    fa->len = READ_ONCE(sqe->len);
>>>>> +    fa->len = READ_ONCE(sqe->addr);
>>>>> +    if (!fa->len)
>>>>> +        fa->len = READ_ONCE(sqe->len);
>>>>>         fa->advice = READ_ONCE(sqe->fadvise_advice);
>>>>>         if (io_fadvise_force_async(fa))
>>>>>             req->flags |= REQ_F_FORCE_ASYNC;
>>>>>
>>>>
>>>>
>>>> If we want to have the length in the same field in both *ADVISE
>>>> operations, we can put a flag in splice_fd_in/optlen.
>>>
>>> I don't think that part matters that much.
>>>
>>>> Maybe the explicit flag is a bit clearer for users of the API
>>>> compared to the implicit flag when setting sqe->len to zero?
>>>
>>> We could go either way. The unused fields returning -EINVAL if set right
>>> now can serve as the flag field - if you have it set, then that is your
>>> length. If not, then the old style is the length. That's the approach I
>>> took, rather than add an explicit flag to it. Existing users that would
>>> set the 64-bit length fields would get -EINVAL already. And since the
>>> normal flags field is already used for advice flags, I'd prefer just
>>> using the existing 64-bit zero fields for it rather than add a flag in
>>> an odd location. Would also make for an easier backport to stable.
>>>
>>> But don't feel that strongly about that part.
>>>
>>> Attached kernel patch with FEAT added, and liburing patch with 64
>>> versions added.
>>>
>>
>> Sounds good!
>> Do we want to do anything about the current (32-bit) functions in
>> liburing? They silently truncate the user's values, so either marking
>> them deprecated or changing the type of length in the arguments to a
>> __u32 could help.
> 
> I like changing it to an __u32, and then we'll add a note to the man
> page for them as well (with references to the 64-bit variants).
> 
> I still need to write a test and actually test the patches, but I'll get
> to that Monday. If you want to write a test case that checks the 64-bit
> range, then please do!
> 

Maybe something like the following for madvise?
Create an 8GB file initialized with 0xaa, punch a (8GB - page_size) hole 
using MADV_REMOVE, and check the contents.
It requires support for FALLOC_FL_PUNCH_HOLE in the filesystem.


diff --git a/test/helpers.c b/test/helpers.c
index 779347f..acf1c7d 100644
--- a/test/helpers.c
+++ b/test/helpers.c
@@ -76,8 +76,9 @@ void *t_calloc(size_t nmemb, size_t size)
   */
  static void __t_create_file(const char *file, size_t size, char pattern)
  {
-	ssize_t ret;
-	char *buf;
+	ssize_t ret = 0;
+	size_t size_remaining;
+	char *buf, *buf_loc;
  	int fd;

  	buf = t_malloc(size);
@@ -86,11 +87,19 @@ static void __t_create_file(const char *file, size_t 
size, char pattern)
  	fd = open(file, O_WRONLY | O_CREAT, 0644);
  	assert(fd >= 0);

-	ret = write(fd, buf, size);
+	size_remaining = size;
+	buf_loc = buf;
+	while (size_remaining > 0) {
+		ret = write(fd, buf_loc, size_remaining);
+		if (ret <= 0)
+			break;
+		size_remaining -= ret;
+		buf_loc += ret;
+	}
  	fsync(fd);
  	close(fd);
  	free(buf);
-	assert(ret == size);
+	assert(size_remaining == 0);
  }

  void t_create_file(const char *file, size_t size)
diff --git a/test/madvise.c b/test/madvise.c
index 7938ec4..b5b0cbe 100644
--- a/test/madvise.c
+++ b/test/madvise.c
@@ -15,34 +15,7 @@
  #include "helpers.h"
  #include "liburing.h"

-#define FILE_SIZE	(128 * 1024)
-
-#define LOOPS		100
-#define MIN_LOOPS	10
-
-static unsigned long long utime_since(const struct timeval *s,
-				      const struct timeval *e)
-{
-	long long sec, usec;
-
-	sec = e->tv_sec - s->tv_sec;
-	usec = (e->tv_usec - s->tv_usec);
-	if (sec > 0 && usec < 0) {
-		sec--;
-		usec += 1000000;
-	}
-
-	sec *= 1000000;
-	return sec + usec;
-}
-
-static unsigned long long utime_since_now(struct timeval *tv)
-{
-	struct timeval end;
-
-	gettimeofday(&end, NULL);
-	return utime_since(tv, &end);
-}
+#define FILE_SIZE	(8ULL * 1024ULL * 1024ULL * 1024ULL)

  static int do_madvise(struct io_uring *ring, void *addr, off_t len, 
int advice)
  {
@@ -76,83 +49,62 @@ static int do_madvise(struct io_uring *ring, void 
*addr, off_t len, int advice)
  		unlink(".madvise.tmp");
  		exit(0);
  	} else if (ret) {
-		fprintf(stderr, "cqe->res=%d\n", cqe->res);
+		fprintf(stderr, "cqe->res=%d (%s)\n", cqe->res,
+			strerror(-cqe->res));
  	}
  	io_uring_cqe_seen(ring, cqe);
  	return ret;
  }

-static long do_copy(int fd, char *buf, void *ptr)
-{
-	struct timeval tv;
-
-	gettimeofday(&tv, NULL);
-	memcpy(buf, ptr, FILE_SIZE);
-	return utime_since_now(&tv);
-}
-
  static int test_madvise(struct io_uring *ring, const char *filename)
  {
-	unsigned long cached_read, uncached_read, cached_read2;
+	size_t page_size;
+	unsigned char contents;
  	int fd, ret;
-	char *buf;
-	void *ptr;
+	unsigned char *ptr;
+
+	page_size = sysconf(_SC_PAGE_SIZE);

-	fd = open(filename, O_RDONLY);
+	fd = open(filename, O_RDWR);
  	if (fd < 0) {
  		perror("open");
  		return 1;
  	}

-	buf = t_malloc(FILE_SIZE);
-
-	ptr = mmap(NULL, FILE_SIZE, PROT_READ, MAP_PRIVATE, fd, 0);
+	ptr = mmap(NULL, FILE_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
  	if (ptr == MAP_FAILED) {
  		perror("mmap");
  		return 1;
  	}

-	cached_read = do_copy(fd, buf, ptr);
-	if (cached_read == -1)
-		return 1;
-
-	cached_read = do_copy(fd, buf, ptr);
-	if (cached_read == -1)
-		return 1;
-
-	ret = do_madvise(ring, ptr, FILE_SIZE, MADV_DONTNEED);
-	if (ret)
-		return 1;
-
-	uncached_read = do_copy(fd, buf, ptr);
-	if (uncached_read == -1)
-		return 1;
-
-	ret = do_madvise(ring, ptr, FILE_SIZE, MADV_DONTNEED);
-	if (ret)
-		return 1;
-
-	ret = do_madvise(ring, ptr, FILE_SIZE, MADV_WILLNEED);
+	ret =
+	    do_madvise(ring, ptr + page_size, FILE_SIZE - page_size,
+		       MADV_REMOVE);
  	if (ret)
  		return 1;

-	msync(ptr, FILE_SIZE, MS_SYNC);
-
-	cached_read2 = do_copy(fd, buf, ptr);
-	if (cached_read2 == -1)
-		return 1;
-
-	if (cached_read < uncached_read &&
-	    cached_read2 < uncached_read)
-		return 0;
+	for (size_t i = 0; i < FILE_SIZE; i++) {
+		contents = ptr[i];
+		if (contents && i > page_size) {
+			fprintf(stderr,
+				"In removed page at %lu but contents=%x\n", i,
+				contents);
+			return 2;
+		} else if (contents != 0xaa && i < page_size) {
+			fprintf(stderr,
+				"In non-removed page at %lu but contents=%x\n",
+				i, contents);
+			return 2;
+		}
+	}

-	return 2;
+	return 0;
  }

  int main(int argc, char *argv[])
  {
  	struct io_uring ring;
-	int ret, i, good, bad;
+	int ret;
  	char *fname;

  	if (argc > 1) {
@@ -167,23 +119,12 @@ int main(int argc, char *argv[])
  		goto err;
  	}

-	good = bad = 0;
-	for (i = 0; i < LOOPS; i++) {
-		ret = test_madvise(&ring, fname);
-		if (ret == 1) {
-			fprintf(stderr, "test_madvise failed\n");
-			goto err;
-		} else if (!ret)
-			good++;
-		else if (ret == 2)
-			bad++;
-		if (i >= MIN_LOOPS && !bad)
-			break;
+	ret = test_madvise(&ring, fname);
+	if (ret) {
+		fprintf(stderr, "test_madvise failed\n");
+		goto err;
  	}

-	/* too hard to reliably test, just ignore */
-	if ((0) && bad > good)
-		fprintf(stderr, "Suspicious timings (%u > %u)\n", bad, good);
  	if (fname != argv[1])
  		unlink(fname);
  	io_uring_queue_exit(&ring);


