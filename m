Return-Path: <io-uring+bounces-11966-lists+io-uring=lfdr.de@vger.kernel.org>
Delivered-To: lists+io-uring@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 2GPsCcKOeml+7wEAu9opvQ
	(envelope-from <io-uring+bounces-11966-lists+io-uring=lfdr.de@vger.kernel.org>)
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 23:33:38 +0100
X-Original-To: lists+io-uring@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BA224A994B
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 23:33:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 241C93008D46
	for <lists+io-uring@lfdr.de>; Wed, 28 Jan 2026 22:33:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7374B3446D8;
	Wed, 28 Jan 2026 22:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fQaPFRaX"
X-Original-To: io-uring@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C3DE29ACD1;
	Wed, 28 Jan 2026 22:33:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769639616; cv=none; b=aZ/wVcrIbnrPmn5k8ZdYm207VobFSQ0baixet3LpYTU+oIBQikNczXDNLBoSP3fuS/6mlBT+wa0pMguX3OvcZFPuTeGynIiDWqF4RWEewXHZAoRoafutDaSSx98x6y7HIv/xSjQvJV/5h7zEzsPUIXVXyOYu5ayVyIy5vDsdXpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769639616; c=relaxed/simple;
	bh=+HZx4uVfXrlII0VOsAjGVpd2yKagMxMZty1h4LjQAPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RFBufD2OpOP9FsxZvqvYpEGEt6jdH3etoOOT1jHpSJwUFqz2G1noCsIWYlPBqNw1vAFza2JO2+trHP30hhz+Gy03+hg1RkM2nCigusZS0g9uTPldYIhidMlSnXg0044CUE348DHsn6O9UjrAblb3vNFkjeA4AtQY60GDoJyWfnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fQaPFRaX; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C70EC116C6;
	Wed, 28 Jan 2026 22:33:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769639616;
	bh=+HZx4uVfXrlII0VOsAjGVpd2yKagMxMZty1h4LjQAPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fQaPFRaXjQq7dP9IFKAl5wj85+lx9JCW4N7dctlXRhBTfRJ940Tq4yYh9H2K3yk1u
	 r01Hn035pGx13fG6jhvPbkWLutGK1LOu1DsQdTNMNbKrxrfXoAlabJuRTi5H4oVDWy
	 XqSo2qoex12KXUt0EhWu6YuC7Gk0XZylBh0ZjbgehpkfQEhN881Z6rTq0Bj6Eq69G9
	 FT4ro+Gi1RQEjLSvQALho3/uveCdalJJb+43k8buFAtHEQkQ3tIWuysbZDcmcccNsT
	 vPdej+NxgNNzxHE2ZnF8vnrg2KG9pR1aJZTxSkxfVpaAJZILoRbVeI7ACeNxGLxsAM
	 Lgq9qNVdSfqRQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jens Axboe <axboe@kernel.dk>,
	Nitesh Shetty <nj.shetty@samsung.com>,
	Sasha Levin <sashal@kernel.org>,
	io-uring@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] io_uring/rw: free potentially allocated iovec on cache put failure
Date: Wed, 28 Jan 2026 17:33:00 -0500
Message-ID: <20260128223332.2806589-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260128223332.2806589-1-sashal@kernel.org>
References: <20260128223332.2806589-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: io-uring@vger.kernel.org
List-Id: <io-uring.vger.kernel.org>
List-Subscribe: <mailto:io-uring+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:io-uring+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.7
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-11966-lists,io-uring=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_TLS_LAST(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[sashal@kernel.org,io-uring@vger.kernel.org];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[io-uring];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	FROM_HAS_DN(0.00)[]
X-Rspamd-Queue-Id: BA224A994B
X-Rspamd-Action: no action

From: Jens Axboe <axboe@kernel.dk>

[ Upstream commit 4b9748055457ac3a0710bf210c229d01ea1b01b9 ]

If a read/write request goes through io_req_rw_cleanup() and has an
allocated iovec attached and fails to put to the rw_cache, then it may
end up with an unaccounted iovec pointer. Have io_rw_recycle() return
whether it recycled the request or not, and use that to gauge whether to
free a potential iovec or not.

Reviewed-by: Nitesh Shetty <nj.shetty@samsung.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now let's understand the scope. This commit fix is for a memory leak bug
in the io_uring rw (read/write) path. Let me summarize my analysis:

## Analysis Summary

### 1. COMMIT MESSAGE ANALYSIS
- **Subject**: "io_uring/rw: free potentially allocated iovec on cache
  put failure"
- **Keywords**: "free", "allocated", "failure" - this is clearly a bug
  fix for a resource leak
- **Description**: When a read/write request goes through
  io_req_rw_cleanup() with an allocated iovec and fails to put to the
  rw_cache, the iovec pointer becomes unaccounted (leaked).
- **Reviewed-by**: Nitesh Shetty (Samsung) - indicates review
- **Author**: Jens Axboe (io_uring maintainer)

### 2. CODE CHANGE ANALYSIS

The bug is in `io_rw_recycle()` and `io_req_rw_cleanup()`:

**Before the fix:**
```c
static void io_rw_recycle(struct io_kiocb *req, unsigned int
issue_flags)
{
    struct io_async_rw *rw = req->async_data;

    if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
        return;  // Early return - iovec potentially leaked

    io_alloc_cache_vec_kasan(&rw->vec);
    if (rw->vec.nr > IO_VEC_CACHE_SOFT_CAP)
        io_vec_free(&rw->vec);

    if (io_alloc_cache_put(&req->ctx->rw_cache, rw))
        io_req_async_data_clear(req, 0);
    // PROBLEM: If io_alloc_cache_put fails (returns false when cache is
full),
    // the rw structure is NOT freed and NOT put back into the cache,
    // but the iovec inside rw->vec is also not freed!
}
```

**After the fix:**
```c
static bool io_rw_recycle(struct io_kiocb *req, unsigned int
issue_flags)
{
    // Returns bool to indicate if recycling succeeded

    if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
        return false;  // Caller knows recycling failed

    // ... same cleanup ...

    if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
        io_req_async_data_clear(req, 0);
        return true;  // Successfully recycled
    }
    return false;  // Failed to recycle - caller will free
}

static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int
issue_flags)
{
    if (!(req->flags & (REQ_F_REISSUE | REQ_F_REFCOUNT))) {
        req->flags &= ~REQ_F_NEED_CLEANUP;
        if (!io_rw_recycle(req, issue_flags)) {
            struct io_async_rw *rw = req->async_data;
            io_vec_free(&rw->vec);  // FIX: Free the iovec if recycle
failed
        }
    }
}
```

### 3. CLASSIFICATION
- **Type**: Bug fix - memory leak
- **Category**: Resource leak in io_uring read/write path
- **Severity**: Medium - leads to memory leak over time with repeated
  I/O operations when cache is full

### 4. SCOPE AND RISK ASSESSMENT
- **Lines changed**: 11 insertions, 4 deletions (small)
- **Files touched**: 1 (io_uring/rw.c)
- **Complexity**: Low - simple return value change and conditional free
- **Risk**: Very low - the fix is straightforward and localized

### 5. USER IMPACT
- **Who is affected**: All io_uring users doing read/write operations
- **How severe**: Memory leak - can cause gradual memory exhaustion on
  systems with heavy io_uring usage
- **Trigger conditions**: When the rw_cache is full (reaches
  IO_ALLOC_CACHE_MAX=128 entries) and a request cleanup occurs

### 6. STABILITY INDICATORS
- **Reviewed-by**: Yes (Nitesh Shetty)
- **Maintainer authored**: Yes (Jens Axboe is the io_uring maintainer)
- **Testing**: The fix is straightforward and has a Reviewed-by tag

### 7. DEPENDENCY CHECK
- The code being fixed was introduced in v6.14-rc1 (commit
  9ac273ae3dc29)
- The `io_vec_free` function exists in v6.15+
- This fix applies cleanly to 6.14+ and 6.15+ stable branches

### Conclusion

This commit should be backported because:

1. **Fixes a real bug**: Memory leak when io_alloc_cache_put fails
2. **Small and surgical**: Only 15 lines changed in one file
3. **Obviously correct**: The fix simply ensures proper cleanup when
   cache insertion fails
4. **No new features**: Just fixes the existing resource management
5. **Low risk**: The change is well-contained and logical
6. **Affects production code**: io_uring is widely used, and memory
   leaks in this path affect real users

The fix is simple: change `io_rw_recycle()` to return a boolean
indicating success/failure, and have `io_req_rw_cleanup()` call
`io_vec_free()` when recycling fails. This ensures the iovec is always
properly freed.

**YES**

 io_uring/rw.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/io_uring/rw.c b/io_uring/rw.c
index abe68ba9c9dc8..d7388a4a3ea5e 100644
--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -144,19 +144,22 @@ static inline int io_import_rw_buffer(int rw, struct io_kiocb *req,
 	return 0;
 }
 
-static void io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
+static bool io_rw_recycle(struct io_kiocb *req, unsigned int issue_flags)
 {
 	struct io_async_rw *rw = req->async_data;
 
 	if (unlikely(issue_flags & IO_URING_F_UNLOCKED))
-		return;
+		return false;
 
 	io_alloc_cache_vec_kasan(&rw->vec);
 	if (rw->vec.nr > IO_VEC_CACHE_SOFT_CAP)
 		io_vec_free(&rw->vec);
 
-	if (io_alloc_cache_put(&req->ctx->rw_cache, rw))
+	if (io_alloc_cache_put(&req->ctx->rw_cache, rw)) {
 		io_req_async_data_clear(req, 0);
+		return true;
+	}
+	return false;
 }
 
 static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
@@ -190,7 +193,11 @@ static void io_req_rw_cleanup(struct io_kiocb *req, unsigned int issue_flags)
 	 */
 	if (!(req->flags & (REQ_F_REISSUE | REQ_F_REFCOUNT))) {
 		req->flags &= ~REQ_F_NEED_CLEANUP;
-		io_rw_recycle(req, issue_flags);
+		if (!io_rw_recycle(req, issue_flags)) {
+			struct io_async_rw *rw = req->async_data;
+
+			io_vec_free(&rw->vec);
+		}
 	}
 }
 
-- 
2.51.0


