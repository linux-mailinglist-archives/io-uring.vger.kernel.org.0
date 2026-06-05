Return-Path: <io-uring+bounces-13615-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id lR5cJZvzImqefgEAu9opvQ
	(envelope-from <io-uring+bounces-13615-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Fri, 05 Jun 2026 18:04:43 +0200
X-Original-To: lists+io-uring@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id C2BFE649921
	for <lists+io-uring@lfdr.de>; Fri, 05 Jun 2026 18:04:42 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="QgKGl/ow";
	spf=pass (mail.lfdr.de: domain of "io-uring+bounces-13615-lists+io-uring=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="io-uring+bounces-13615-lists+io-uring=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 401AF309C64B
	for <lists+io-uring@lfdr.de>; Fri,  5 Jun 2026 15:55:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 73D4F3B71A5;
	Fri,  5 Jun 2026 15:55:50 +0000 (UTC)
X-Original-To: io-uring@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 941F43B7B90
	for <io-uring@vger.kernel.org>; Fri,  5 Jun 2026 15:55:48 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780674950; cv=none; b=MMf++DqoB6+aaQyzkYOPNiIdmoIMB/o8DViWtd2Im+ISaO1tZxB4n57cfBMhof/29JPmLtZMEb4nerZWmgZ/u3YAmTIRlhJ1vDS61bKDKKWynymhENG0b1hIa6IfeLKvnEd6sOY7UYoVmAXIs1GH7xyHQpx7GRKon03ET0tuW4k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780674950; c=relaxed/simple;
	bh=oo+qg27qYE0n8gpQZLCin67+eDUqjw9tV+uS7M9VbGc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=T/0oAVE1wVD+/X1CMLwt6Y8juaYz+msgrJh7TQNHbh9HW407uVojk6q7CuHkXcYPu0Y87BIAZA6Nu3mbRaa+gq+xSBTxzQQjI/uJv3B4ydXwmWgEWawaALWcsNkhT5uxucxF7H/61zoEgy6aIHdKVeza/6p/Zg74VAGQRaUkVZs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=QgKGl/ow; arc=none smtp.client-ip=170.10.129.124
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1780674947;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gt1/btrN7lXbnKttsU6AcQkjRlXNdPkL/4HGFotiNrE=;
	b=QgKGl/owMmNCUbtONMvl9c1t7jIPH35uTbqo15NVoYw74ieNUDWe8mPFoJ0x+Ur6fSerOk
	BUYEJUDwRnAZtRjgaEHhGnJ14qosSbUAYi3ftB/08+QgvMFGt+ad07HBxRQS2sJUIWeQ+k
	O6c7zAyQNEG5XJ04qg5O7blMrwB4/Ow=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-333-Qof5n4KvPuy329yZXyl75g-1; Fri,
 05 Jun 2026 11:55:46 -0400
X-MC-Unique: Qof5n4KvPuy329yZXyl75g-1
X-Mimecast-MFC-AGG-ID: Qof5n4KvPuy329yZXyl75g_1780674944
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id CAF67180048E;
	Fri,  5 Jun 2026 15:55:43 +0000 (UTC)
Received: from bfoster (unknown [10.22.88.95])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C2AF18004D4;
	Fri,  5 Jun 2026 15:55:41 +0000 (UTC)
Date: Fri, 5 Jun 2026 11:55:39 -0400
From: Brian Foster <bfoster@redhat.com>
To: Gregg Leventhal <gleventhal@janestreet.com>
Cc: hch@infradead.org, djwong@kernel.org,
	Eric Hagberg <ehagberg@janestreet.com>, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, io-uring@vger.kernel.org,
	Jens Axboe <axboe@kernel.dk>, stable@vger.kernel.org
Subject: Re: [BUG] iomap/io_uring: O_APPEND async buffered write silently
 re-appends a data chunk (corruption) on XFS, 6.1.y/6.12.y
Message-ID: <aiLxe-9Sub8cI3Py@bfoster>
References: <CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAFN_u7FrgM4Dzie2jjkLwWV8P0dvUG_Wwy3Q9B3-2HnnWiDu8w@mail.gmail.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93
X-Rspamd-Action: no action
X-Spamd-Result: default: False [2.34 / 15.00];
	MID_END_EQ_FROM_USER_PART(4.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[redhat.com,quarantine];
	MID_RHS_NOT_FQDN(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[redhat.com:s=mimecast20190719];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-13615-lists,io-uring=lfdr.de];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:gleventhal@janestreet.com,m:hch@infradead.org,m:djwong@kernel.org,m:ehagberg@janestreet.com,m:linux-xfs@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:io-uring@vger.kernel.org,m:axboe@kernel.dk,m:stable@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[bfoster@redhat.com,io-uring@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[redhat.com:+];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	MISSING_XM_UA(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[bfoster@redhat.com,io-uring@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[9];
	TO_DN_SOME(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,bfoster:mid,janestreet.com:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: C2BFE649921

On Thu, Jun 04, 2026 at 02:46:33PM -0400, Gregg Leventhal wrote:
> Hi all,
> 
> We're seeing silent data corruption -- a chunk of a buffered write being
> silently repeated at a later offset -- when using io_uring async buffered
> writes with O_APPEND on XFS. It reproduces on the longterm stable trees
> 6.1.y and 6.12.y under memory pressure, and is fixed in 6.18.y.
> 
...
> What fixes it
> -------------
> We did not bisect. We identified Brian Foster's "iomap: incremental
> per-operation iter advance" series as the likely relevant change,
> backported it to the affected kernel, and confirmed it makes the
> reproducer pass. The series was merged for v6.15:
> 
>   [1]https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h
> =linux-6.18.y&id=30f530096166202cf70e1b7d1de5a8cdfba42af1
> 
> It reworks iomap_write_iter() to advance iter->pos/iter->len incrementally
> (iomap_iter_advance) and removes the iov_iter_revert/-EAGAIN handling, so
> retries resume from the correct offset. The buffered-write change is in
> "iomap: advance the iter directly on buffered writes" (d9dc477ff6a2), but
> it depends on the earlier infrastructure patches in the same series.
> 

Note: the correct hash for the buffered write change is 1a1a3b574b97
("iomap: advance the iter directly on buffered writes"). The hash
referenced above is the commit for the read path.

Thanks for the legwork here. I'm at least glad to see I accidentally
fixed something vs. breaking it for a change. ;) I am slightly wondering
if the fundamental issue here is splitting the append write into two
partial requests and whether that's racy wrt EOF, not necessarily the
pos tracking added by this patch.

For example, if we assume the same sort of append+nowait -> partial
write -> append retry loop via io_uring on the current code, but then
inject some other append write (or i_size change) between the two split
writes, wouldn't that result in a similar problem? I don't think we'd
rewrite the original data again, but maybe data ends up interleaved or
something.

But anyways looking back at that commit, I think the relevant behavior
change is that ki_pos update is made consistent with whatever partial
completion iomap_write_iter() may have performed. More specifically, the
older code doesn't update iter->pos until after a successful iomap
iteration (via iomap_iter()). This means that if we loop within
iomap_write_iter() one or more times before hitting an -EAGAIN, the
local pos update is lost and doesn't reflect back into the iomap_iter or
thus the assignment to iocb->ki_pos in the caller
(iomap_file_buffered_write()). Therefore, we revert the iov iter so it
is consistent with ki_pos at the start of the current iter.  However we
have an append write in this case and i_size is updated within
iomap_write_iter(), so the write retry will overwrite ki_pos to the
new/updated EOF IIUC (via generic_write_checks_count(), called from the
fs before calling into iomap) and result in the observed behavior of
rewriting some amount of data to a new file offset.

The updated code bumps iter->pos incrementally within
iomap_write_iter(). We don't need to revert the iov_iter anymore because
incremental progress will be reflected back to iocb->ki_pos via
iter->pos. However this also happens to be consistent with incremental
i_size updates within iomap_write_iter(), so (as long as we don't race,
I think) the retry should be consistent and pick up where the partial
write left off.

One thing I might try here is to see if just deferring append writes to
!NOWAIT context avoids this problem because I wonder how sane that sort
of retry situation really is. I'm not quite sure what the expectations
are in that sort of case. Is that something that's easy to test? Of
course that wouldn't prevent this issue if other applications have this
same write pattern.

Another potential option for a stable only fix might be tweak the iomap
code to not update i_size for append (&& nowait?) writes until an
iter->pos update is imminent, but I think we'd need to be careful there
due to the pagecache_isize_extended() call. I think that's more for
non-append cases, but I'd have to take a closer look. Maybe we could
also replace that iov_iter revert with a hardcoded advance of the iomap
iter and emulate the same behavior as newer kernels. That seems
cleanest actually, but again needs some thought and testing...

Brian

> Detection in the reproducer (both silent)
> -----------------------------------------
>   1) final file size > sum of CQE byte counts the kernel reported.
>   2) the file is filled with a u64 "byte offset / 8" pattern, so on
>      readback element j must equal j; the first mismatch marks the start
>      of the duplicated copy (observed to be page-aligned).
> 
> Reproducer
> ----------
> Build: gcc -O2 -o repro_uring_dup repro_uring_dup.c -luring
> Run:   ./repro_uring_dup /path/on/xfs/repro [seconds] [file_target_mb]
> Needs the system under memory pressure to trigger; under those conditions
> it reproduces reliably. Source attached (repro_uring_dup.c).
> 
> Notes on stable
> ---------------
> The fix is a refactor with no Fixes: tag, and the buffered-write commit
> builds on the preceding patches in the series, so a single-commit
> cherry-pick into 6.1.y / 6.12.y doesn't look feasible. We're wondering
> whether a smaller, targeted fix would be more backportable for the active
> LTS trees -- e.g. ensuring the -EAGAIN retry path keeps the append
> position consistent with the reverted iov_iter so the already-committed
> range isn't re-appended -- but we'd defer to your judgment on whether that
> is sound or whether backporting the series as a unit is the better path.
> Given this is silent data corruption present since io_uring async buffered
> write support (~v6.0), we'd appreciate guidance on the right approach.
> 
> Happy to test patches and provide any additional detail.
> 
> Regards,
> Gregg Leventhal <[2]gleventhal@janestreet.com> and Eric Hagberg <[3]
> ehagberg@janestreet.com>
> 
> References:
> 
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/commit/?h=linux-6.18.y&id=30f530096166202cf70e1b7d1de5a8cdfba42af1
> [2] mailto:gleventhal@janestreet.com
> [3] mailto:ehagberg@janestreet.com

> /*
>  * repro_uring_dup.c
>  *
>  * Reproducer for io_uring async buffered-write duplication on XFS.
>  * Issues large, variable-size, non-page-aligned buffered writev's appended
>  * to a file via io_uring with offset -1 ("use current position").
>  *
>  * Bug: when the inline IOCB_NOWAIT attempt does a partial-page short write
>  * (landing on a page boundary) and the page-aligned remainder is reissued on
>  * io-wq, a page-aligned, page-multiple sub-range of the remainder is written
>  * TWICE, while the CQE still reports the full requested byte count. Result:
>  * the file is larger than the bytes we were told succeeded, with a page-aligned
>  * duplicated chunk.
>  *
>  * Detection (both silent - no error is ever returned):
>  *   1) final file size > total bytes the kernel told us it wrote.
>  *   2) file is filled with a u64 "byte offset / 8" pattern, so on readback
>  *      element j must equal j; the first j where it doesn't is the start of the
>  *      duplicated copy (expected to be page-aligned).
>  *
>  * Build:  gcc -O2 -o repro_uring_dup repro_uring_dup.c -luring
>  * Run:    ./repro_uring_dup /path/on/xfs/repro [seconds] [file_target_mb]
>  */
> #define _GNU_SOURCE
> #include <liburing.h>
> #include <fcntl.h>
> #include <stdint.h>
> #include <stdio.h>
> #include <stdlib.h>
> #include <string.h>
> #include <time.h>
> #include <unistd.h>
> #include <errno.h>
> #include <sys/stat.h>
> #include <sys/uio.h>
> 
> #define QD 8
> #define MB (1024UL * 1024UL)
> #define MAXCHUNK (24UL * MB)
> #define MINCHUNK (1UL * MB)
> 
> /* 1: O_APPEND / offset -1 variant (corrupts).
>  * 0: no O_APPEND, explicit offset variant (does not corrupt). */
> static int use_append = 1;
> 
> static uint64_t now_ns(void) {
>   struct timespec ts;
>   clock_gettime(CLOCK_MONOTONIC, &ts);
>   return (uint64_t)ts.tv_sec * 1000000000ULL + (uint64_t)ts.tv_nsec;
> }
> 
> /* Fill buf so the u64 at global byte offset (base+8*i) holds (base+8*i)/8. */
> static void fill_pattern(uint64_t *buf, uint64_t base_bytes, size_t len) {
>   uint64_t start_idx = base_bytes / 8;
>   size_t n = len / 8;
>   for (size_t i = 0; i < n; i++)
>     buf[i] = start_idx + i;
> }
> 
> /* One writev; loops over (legitimately) short *returned* results. */
> static void write_all(struct io_uring *ring, int fd, uint8_t *buf, size_t len,
>                       uint64_t expected) {
>   size_t done = 0;
>   while (done < len) {
>     struct io_uring_sqe *sqe = io_uring_get_sqe(ring);
>     struct iovec iov = {.iov_base = buf + done, .iov_len = len - done};
>     long long off = use_append ? -1LL : (long long)(expected + done);
>     io_uring_prep_writev(sqe, fd, &iov, 1, (unsigned long long)off);
> 
>     int ret = io_uring_submit(ring);
>     if (ret < 0) {
>       fprintf(stderr, "submit: %s\n", strerror(-ret));
>       exit(1);
>     }
> 
>     struct io_uring_cqe *cqe;
>     ret = io_uring_wait_cqe(ring, &cqe);
>     if (ret < 0) {
>       fprintf(stderr, "wait_cqe: %s\n", strerror(-ret));
>       exit(1);
>     }
>     int res = cqe->res;
>     io_uring_cqe_seen(ring, cqe);
> 
>     if (res < 0) {
>       fprintf(stderr, "write: %s\n", strerror(-res));
>       exit(1);
>     }
>     if (res == 0) {
>       fprintf(stderr, "write returned 0\n");
>       exit(1);
>     }
>     done += (size_t)res;
>   }
> }
> 
> int main(int argc, char **argv) {
>   if (argc < 2) {
>     fprintf(stderr, "usage: %s <path-prefix-on-xfs> [seconds] [file_target_mb]\n",
>             argv[0]);
>     return 2;
>   }
>   const char *prefix = argv[1];
>   int seconds = (argc > 2) ? atoi(argv[2]) : 60;
>   uint64_t file_target = ((argc > 3) ? (uint64_t)atoll(argv[3]) : 48) * MB;
> 
>   srand((unsigned)(time(NULL) ^ getpid()));
> 
>   struct io_uring ring;
>   if (io_uring_queue_init(QD, &ring, 0)) {
>     perror("io_uring_queue_init");
>     return 1;
>   }
> 
>   uint8_t *buf = aligned_alloc(4096, MAXCHUNK);
>   if (!buf) {
>     perror("aligned_alloc");
>     return 1;
>   }
> 
>   static uint64_t rbuf[1 << 16];
>   uint64_t deadline = now_ns() + (uint64_t)seconds * 1000000000ULL;
>   long files = 0;
> 
>   while (now_ns() < deadline) {
>     char fn[8192];
>     snprintf(fn, sizeof fn, "%s.%ld", prefix, files);
>     int flags = O_WRONLY | O_CREAT | O_TRUNC | (use_append ? O_APPEND : 0);
>     int fd = open(fn, flags, 0644);
>     if (fd < 0) {
>       perror("open");
>       return 1;
>     }
> 
>     uint64_t expected = 0;
>     while (expected < file_target) {
>       size_t want = MINCHUNK + ((size_t)rand() % (MAXCHUNK - MINCHUNK));
>       want &= ~((size_t)7); /* 8-align; deliberately NOT page-aligned */
>       fill_pattern((uint64_t *)buf, expected, want);
>       write_all(&ring, fd, buf, want, expected);
>       expected += want; /* CQE reported full success */
>     }
>     close(fd);
> 
>     /* ---- verify ---- */
>     struct stat st;
>     if (stat(fn, &st)) {
>       perror("stat");
>       return 1;
>     }
> 
>     long long first_bad = -1;
>     uint64_t bad_val = 0;
>     int rfd = open(fn, O_RDONLY);
>     if (rfd < 0) {
>       perror("open ro");
>       return 1;
>     }
>     uint64_t idx = 0;
>     ssize_t r;
>     while ((r = read(rfd, rbuf, sizeof rbuf)) > 0) {
>       size_t cnt = (size_t)r / 8;
>       for (size_t i = 0; i < cnt; i++) {
>         if (rbuf[i] != idx) {
>           first_bad = (long long)(idx * 8);
>           bad_val = rbuf[i];
>           break;
>         }
>         idx++;
>       }
>       if (first_bad >= 0)
>         break;
>     }
>     close(rfd);
> 
>     int bug = ((uint64_t)st.st_size != expected) || (first_bad >= 0);
>     files++;
> 
>     if (bug) {
>       printf("\n*** CORRUPTION DETECTED in %s ***\n", fn);
>       printf("  bytes kernel said it wrote (sum of CQE results): %llu\n",
>              (unsigned long long)expected);
>       printf("  actual file size:                                %llu\n",
>              (unsigned long long)st.st_size);
>       printf("  extra (duplicated) bytes:                        %lld\n",
>              (long long)st.st_size - (long long)expected);
>       if (first_bad >= 0) {
>         printf("  first mismatching offset: %lld (0x%llx)  page_aligned=%s\n", first_bad,
>                (unsigned long long)first_bad, (first_bad % 4096 == 0) ? "YES" : "no");
>         printf("    expected u64 %llu but found %llu "
>                "(content from byte offset %llu reappeared here)\n",
>                (unsigned long long)(first_bad / 8), (unsigned long long)bad_val,
>                (unsigned long long)(bad_val * 8));
>       }
>       printf("  (file kept for inspection)\n");
>       io_uring_queue_exit(&ring);
>       return 0;
>     }
>     unlink(fn);
>     if (files % 20 == 0)
>       fprintf(stderr, "...%ld files clean\n", files);
>   }
> 
>   printf("No corruption in %d s (%ld files). Try more time, parallel instances, "
>          "or memory pressure.\n",
>          seconds, files);
>   io_uring_queue_exit(&ring);
>   free(buf);
>   return 0;
> }


